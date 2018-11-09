data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "null_resource" "repo_cheat" {
  triggers {
    repo = "${var.team_name}/${var.repo_name}"
  }

  provisioner "local-exec" {
    command = "aws ecr create-repository --repository-name ${var.team_name}/${var.repo_name} || echo \"${var.team_name}/${var.repo_name} already created\""
  }
}

resource "aws_iam_user" "user" {
  name = "ecr-user-${var.team_name}"
  path = "/system/ecr-user/"
}

resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:DescribeRepositories",
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
    ]

    resources = [
      "arn:aws:ecr:*:*:repository/${var.team_name}/*",
    ]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]

    resources = [
      "arn:aws:ecr:*:*:repository/${var.team_name}/*",
    ]
  }
}

resource "aws_iam_user_policy" "policy" {
  name   = "ecr-${var.team_name}"
  policy = "${data.aws_iam_policy_document.policy.json}"
  user   = "${aws_iam_user.user.name}"
}
