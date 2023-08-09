locals {
  # GitHub configuration
  github_repositories = toset([
    for repository in var.github_repositories : {
      repository = repository
    }
  ])
  github_environments = toset([
    for environment in var.github_environments : {
      environment = environment
    }
  ])
  github_repo_environments = [
    for pair in setproduct(local.github_repositories, local.github_environments) : {
      repository  = pair[0].repository
      environment = pair[1].environment
    }
  ]

  # Tags
  default_tags = {
    # Mandatory
    business-unit = var.business_unit
    application   = var.application
    is-production = var.is_production
    owner         = var.team_name
    namespace     = var.namespace # for billing and identification purposes

    # Optional
    environment-name       = var.environment_name
    infrastructure-support = var.infrastructure_support
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ECR repository
resource "aws_ecr_repository" "repo" {
  name = "${var.team_name}/${var.repo_name}"
  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = var.deletion_protection ? false : true

  tags = local.default_tags
}

# ECR lifecycle policy
resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count      = var.lifecycle_policy == null ? 0 : 1
  repository = aws_ecr_repository.repo.name
  policy     = var.lifecycle_policy
}

# Canned lifecycle policies
locals {
  canned_lifecycle_policies = {
    days = {
      rules = [
        {
          rulePriority = 1
          description  = "Expire images older than ${try(var.canned_lifecycle_policy.count, 0)} day(s)"
          selection = {
            tagStatus   = "any"
            countType   = "sinceImagePushed"
            countUnit   = "days"
            countNumber = try(var.canned_lifecycle_policy.count, null)
          }
          action = {
            type = "expire"
          }
        }
      ]
    }
    images = {
      rules = [
        {
          rulePriority = 1
          description  = "Retain ${try(var.canned_lifecycle_policy.count, 0)} newest images, expire all others"
          selection = {
            tagStatus   = "any"
            countType   = "imageCountMoreThan"
            countNumber = try(var.canned_lifecycle_policy.count, null)
          }
          action = {
            type = "expire"
          }
        }
      ]
    }
  }
}

resource "aws_ecr_lifecycle_policy" "canned" {
  count      = (var.canned_lifecycle_policy != null) && (var.lifecycle_policy == null) ? 1 : 0
  repository = aws_ecr_repository.repo.name
  policy     = (var.canned_lifecycle_policy != null) ? jsonencode(local.canned_lifecycle_policies[var.canned_lifecycle_policy.type]) : null
}

####################
# IRSA integration #
####################

# Short-lived credentials (IRSA)
# Note: This has a separate policy to OIDC as this should only be used for
# inspecting images from a service pod rather than pushing an image
data "aws_iam_policy_document" "irsa" {
  version = "2012-10-17"

  statement {
    sid       = "AllowLogin"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowReadOnly"
    effect = "Allow"
    actions = [
      # General
      "ecr:ListTagsForResource",

      # Repositories
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",

      # Lifecycle policies
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:StartLifecyclePolicyPreview",

      # Images
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",

      # Layers
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
    ]
    resources = [aws_ecr_repository.repo.arn]
  }
}

resource "aws_iam_policy" "irsa" {
  name   = "${local.oidc_identifier}-irsa"
  path   = "/cloud-platform/ecr/"
  policy = data.aws_iam_policy_document.irsa.json
  tags   = local.default_tags
}

####################
# OIDC integration #
####################
data "aws_secretsmanager_secret" "circleci" {
  name = "cloud-platform-circleci"
}

data "aws_secretsmanager_secret_version" "circleci" {
  secret_id = data.aws_secretsmanager_secret.circleci.id
}

locals {
  # Identifiers
  oidc_identifier = "cloud-platform-ecr-${random_id.oidc.hex}"

  # Providers
  oidc_providers = {
    github   = "token.actions.githubusercontent.com"
    circleci = "oidc.circleci.com/org/${jsondecode(data.aws_secretsmanager_secret_version.circleci.secret_string)["organisation_id"]}"
  }

  # GitHub
  enable_github = contains(var.oidc_providers, "github")
  github_repos  = toset(var.github_repositories)
  github_envs   = toset(var.github_environments)
  github_repo_envs = {
    for pair in setproduct(local.github_repos, local.github_envs) :
    "${pair[0]}.${pair[1]}" => {
      repository  = pair[0]
      environment = pair[1]
    }
  }
  github_actions_prefix = upper(var.github_actions_prefix)
  github_variable_names = {
    ECR_ROLE_TO_ASSUME = join("_", compact([local.github_actions_prefix, "ECR_ROLE_TO_ASSUME"]))
    ECR_REGION         = join("_", compact([local.github_actions_prefix, "ECR_REGION"]))
    ECR_REPOSITORY     = join("_", compact([local.github_actions_prefix, "ECR_REPOSITORY"]))
  }

  # CircleCI
  enable_circleci          = contains(var.oidc_providers, "circleci")
  circleci_organisation_id = jsondecode(data.aws_secretsmanager_secret_version.circleci.secret_string)["organisation_id"]
}

# Random ID for identifiers
resource "random_id" "oidc" {
  byte_length = 8
}

# Base ECR policy for pushing and pulling images, can be used across all OIDC providers
# Also allows listing existing images and deleting them
# See: https://github.com/aws-actions/amazon-ecr-login#permissions
data "aws_iam_policy_document" "base" {
  version = "2012-10-17"

  statement {
    sid       = "AllowLogin"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowPushPullListDelete"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchDeleteImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [aws_ecr_repository.repo.arn]
  }
}

# You can reuse this policy across multiple roles
resource "aws_iam_policy" "ecr" {
  count = (length(var.oidc_providers) > 0) ? 1 : 0

  name   = local.oidc_identifier
  policy = data.aws_iam_policy_document.base.json
  tags   = local.default_tags
}

# GitHub: OIDC provider
data "aws_iam_openid_connect_provider" "github" {
  url = "https://${local.oidc_providers.github}"
}

# GitHub: Assume role policy
# See: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws
data "aws_iam_policy_document" "github" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = (length(local.github_repos) == 1) ? "StringLike" : "ForAnyValue:StringLike"
      variable = "${local.oidc_providers.github}:sub"
      values   = formatlist("repo:ministryofjustice/%s:*", local.github_repos)
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_providers.github}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# IAM role and policy attachment for ECR
resource "aws_iam_role" "github" {
  count = local.enable_github ? 1 : 0

  name               = "${local.oidc_identifier}-github"
  assume_role_policy = data.aws_iam_policy_document.github.json

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "github_ecr" {
  count = local.enable_github ? 1 : 0

  role       = aws_iam_role.github[0].name
  policy_arn = aws_iam_policy.ecr[0].arn
}

# Actions
resource "github_actions_secret" "ecr_role_to_assume" {
  for_each = local.enable_github ? local.github_repos : []

  repository      = each.value
  secret_name     = local.github_variable_names["ECR_ROLE_TO_ASSUME"]
  plaintext_value = aws_iam_role.github[0].arn
}

resource "github_actions_variable" "ecr_region" {
  for_each = local.enable_github ? local.github_repos : []

  repository    = each.value
  variable_name = local.github_variable_names["ECR_REGION"]
  value         = data.aws_region.current.name
}

resource "github_actions_variable" "ecr_repository" {
  for_each = local.enable_github ? local.github_repos : []

  repository    = each.value
  variable_name = local.github_variable_names["ECR_REPOSITORY"]
  value         = aws_ecr_repository.repo.name
}

# Environments
resource "github_actions_environment_secret" "ecr_role_to_assume" {
  for_each = local.enable_github ? local.github_repo_envs : {}

  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = local.github_variable_names["ECR_ROLE_TO_ASSUME"]
  plaintext_value = aws_iam_role.github[0].arn
}

resource "github_actions_environment_variable" "ecr_region" {
  for_each = local.enable_github ? local.github_repo_envs : {}

  repository    = each.value.repository
  environment   = each.value.environment
  variable_name = local.github_variable_names["ECR_REGION"]
  value         = data.aws_region.current.name
}

resource "github_actions_environment_variable" "ecr_repository" {
  for_each = local.enable_github ? local.github_repo_envs : {}

  repository    = each.value.repository
  environment   = each.value.environment
  variable_name = local.github_variable_names["ECR_REPOSITORY"]
  value         = aws_ecr_repository.repo.name
}

# CircleCI: OIDC provider
data "aws_iam_openid_connect_provider" "circleci" {
  url = "https://${local.oidc_providers.circleci}"
}

# CircleCI: Assume role policy
# See: https://circleci.com/docs/openid-connect-tokens/#advanced-usage
# The :sub value requires a user to use version 2 (not version 1) of CircleCI's OIDC token,
# as that is the only way to restrict the push by the VCS (e.g. GitHub) origin.
data "aws_iam_policy_document" "circleci" {
  version = "2012-10-17"

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.circleci.arn]
    }

    condition {
      test     = (length(local.github_repos) == 1) ? "StringLike" : "ForAnyValue:StringLike"
      variable = "${local.oidc_providers.circleci}:sub"
      values   = formatlist("org/${local.circleci_organisation_id}/project/*/user/*/vcs-origin/github.com/ministryofjustice/%s/vcs-ref/refs/heads/*", local.github_repos)
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_providers.circleci}:aud"
      values   = [local.circleci_organisation_id]
    }
  }
}

# IAM role and policy attachment for ECR
resource "aws_iam_role" "circleci" {
  count = local.enable_circleci ? 1 : 0

  name               = "${local.oidc_identifier}-circleci"
  assume_role_policy = data.aws_iam_policy_document.circleci.json

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "circleci_ecr" {
  count = local.enable_circleci ? 1 : 0

  role       = aws_iam_role.circleci[0].name
  policy_arn = aws_iam_policy.ecr[0].arn
}

# Create a ConfigMap for a user to retrieve the ECR_* variables
# as they need to be set in CircleCI manually
resource "kubernetes_config_map_v1" "circleci_oidc" {
  count = (local.enable_circleci && (var.namespace != null)) ? 1 : 0

  metadata {
    name      = "${replace(var.repo_name, "_", "-")}-circleci"
    namespace = var.namespace
  }

  data = {
    ecr_role_to_assume = aws_iam_role.circleci[0].arn
    ecr_region         = data.aws_region.current.name
    ecr_repository     = aws_ecr_repository.repo.name
    ecr_registry_id    = data.aws_caller_identity.current.account_id
  }
}
