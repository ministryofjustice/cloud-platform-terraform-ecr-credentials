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

resource "aws_ecr_repository" "repo" {
  name = "${var.team_name}/${var.repo_name}"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

# Lifecycle policy
resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  count      = var.lifecycle_policy == null ? 0 : 1
  repository = aws_ecr_repository.repo.name
  policy     = var.lifecycle_policy
}

resource "random_id" "user" {
  byte_length = 8
}

resource "aws_iam_user" "user" {
  name = "ecr-user-${random_id.user.hex}"
  path = "/system/ecr-user/${var.team_name}/"
}

resource "aws_iam_access_key" "key_2023" {
  user   = aws_iam_user.user.name
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


# Create environment secrets

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
