locals {
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
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ECR repository
resource "aws_ecr_repository" "repo" {
  name = "${var.team_name}/${var.repo_name}"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

# ECR lifecycle policy
resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count      = var.lifecycle_policy == null ? 0 : 1
  repository = aws_ecr_repository.repo.name
  policy     = var.lifecycle_policy
}

# Legacy access (IAM access keys)
resource "random_id" "user" {
  byte_length = 8
}

resource "aws_iam_user" "user" {
  name = "ecr-user-${random_id.user.hex}"
  path = "/system/ecr-user/${var.team_name}/"
}

resource "aws_iam_access_key" "key_2023" {
  user = aws_iam_user.user.name
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:ListTagsForResource",
      "ecr:DescribeImageScanFindings",
      "inspector2:List*",
      "inspector2:Get*"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:BatchDeleteImage",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy"
    ]

    resources = [
      "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/${var.team_name}/*",
    ]
  }
}

resource "aws_iam_user_policy" "policy" {
  name   = "ecr-read-write"
  policy = data.aws_iam_policy_document.policy.json
  user   = aws_iam_user.user.name
}

# Legacy GitHub integration: create GitHub Actions secrets
resource "github_actions_secret" "ecr_url" {
  for_each        = toset(var.github_repositories)
  repository      = each.key
  secret_name     = var.github_actions_secret_ecr_url
  plaintext_value = trimspace(aws_ecr_repository.repo.repository_url)
}

resource "github_actions_secret" "ecr_name" {
  for_each        = toset(var.github_repositories)
  repository      = each.key
  secret_name     = var.github_actions_secret_ecr_name
  plaintext_value = trimspace(aws_ecr_repository.repo.name)
}

resource "github_actions_secret" "ecr_access_key" {
  for_each        = toset(var.github_repositories)
  repository      = each.key
  secret_name     = var.github_actions_secret_ecr_access_key
  plaintext_value = aws_iam_access_key.key_2023.id
}

resource "github_actions_secret" "ecr_secret_key" {
  for_each        = toset(var.github_repositories)
  repository      = each.key
  secret_name     = var.github_actions_secret_ecr_secret_key
  plaintext_value = aws_iam_access_key.key_2023.secret
}

# Legacy GitHub integration: Create environment secrets
resource "github_actions_environment_secret" "ecr_url" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_ecr_url
  plaintext_value = trimspace(aws_ecr_repository.repo.repository_url)
}

resource "github_actions_environment_secret" "ecr_name" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_ecr_name
  plaintext_value = trimspace(aws_ecr_repository.repo.name)
}

resource "github_actions_environment_secret" "ecr_access_key" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_ecr_access_key
  plaintext_value = aws_iam_access_key.key_2023.id
}

resource "github_actions_environment_secret" "ecr_secret_key" {
  for_each = {
    for i in local.github_repo_environments : "${i.repository}.${i.environment}" => i
  }
  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = var.github_actions_secret_ecr_secret_key
  plaintext_value = aws_iam_access_key.key_2023.secret
}

####################
# OIDC integration #
####################
locals {
  oidc_providers = {
    github = "token.actions.githubusercontent.com"
  }

  oidc_providers_assume_role_policies = {
    github = data.aws_iam_policy_document.github.json
  }

  identifier_oidc = "cloud-platform-ecr-${random_id.oidc.hex}"
}

# Random ID for identifiers
resource "random_id" "oidc" {
  byte_length = 8
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
      test     = length(var.github_repositories) == 1 ? "StringLike" : "ForAnyValue:StringLike"
      variable = "${local.oidc_providers.github}:sub"
      values   = formatlist("repo:ministryofjustice/%s:*", toset(var.github_repositories))
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_providers.github}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# ECR policy
# See: https://github.com/aws-actions/amazon-ecr-login#permissions
data "aws_iam_policy_document" "ecr" {
  version = "2012-10-17"
  statement {
    sid       = "AllowLogin"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowPushPull"
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [aws_ecr_repository.repo.arn]
  }
}

# IAM roles, policies, and policy attachments
resource "aws_iam_role" "oidc" {
  for_each = toset(var.oidc_providers) # one role per provider

  name               = "${local.identifier_oidc}-${each.key}"
  assume_role_policy = local.oidc_providers_assume_role_policies[each.key]
}

resource "aws_iam_policy" "ecr" {
  name   = local.identifier_oidc
  policy = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_role_policy_attachment" "ecr" {
  for_each = aws_iam_role.oidc

  role       = each.value.name
  policy_arn = aws_iam_policy.ecr.arn
}

# GitHub Actions variables and secrets
locals {
  github_variable_names = {
    ECR_ROLE_TO_ASSUME = upper(join("_", compact([var.github_actions_prefix, "ECR_ROLE_TO_ASSUME"])))
    ECR_REGION         = upper(join("_", compact([var.github_actions_prefix, "ECR_REGION"])))
    ECR_REPOSITORY     = upper(join("_", compact([var.github_actions_prefix, "ECR_REPOSITORY"])))
  }

  github_repos = toset(var.github_repositories)
  github_envs  = toset(var.github_environments)
  github_repo_envs = {
    for pair in setproduct(local.github_repos, local.github_envs) :
    "${pair[0]}.${pair[1]}" => {
      repository  = pair[0]
      environment = pair[1]
    }
  }
}

# Actions
resource "github_actions_secret" "role_to_assume" {
  for_each = contains(var.oidc_providers, "github") ? local.github_repos : []

  repository      = each.key
  secret_name     = local.github_variable_names["ECR_ROLE_TO_ASSUME"]
  plaintext_value = aws_iam_role.oidc["github"].arn

  depends_on = [aws_iam_role.oidc]
}

resource "github_actions_variable" "ecr_region" {
  for_each = local.github_repos

  repository    = each.key
  variable_name = local.github_variable_names["ECR_REGION"]
  value         = data.aws_region.current.name
}

resource "github_actions_variable" "ecr_repository" {
  for_each = local.github_repos

  repository    = each.key
  variable_name = local.github_variable_names["ECR_REPOSITORY"]
  value         = aws_ecr_repository.repo.name
}

# Environments
resource "github_actions_environment_secret" "role_to_assume" {
  for_each = contains(var.oidc_providers, "github") ? local.github_repo_envs : {}

  repository      = each.value.repository
  environment     = each.value.environment
  secret_name     = local.github_variable_names["ECR_ROLE_TO_ASSUME"]
  plaintext_value = aws_iam_role.oidc["github"].arn

  depends_on = [aws_iam_role.oidc]
}

resource "github_actions_environment_variable" "ecr_region" {
  for_each = local.github_repo_envs

  repository    = each.value.repository
  environment   = each.value.environment
  variable_name = local.github_variable_names["ECR_REGION"]
  value         = data.aws_region.current.name
}

resource "github_actions_environment_variable" "ecr_repository" {
  for_each = local.github_repo_envs

  repository    = each.value.repository
  environment   = each.value.environment
  variable_name = local.github_variable_names["ECR_REPOSITORY"]
  value         = aws_ecr_repository.repo.name
}
