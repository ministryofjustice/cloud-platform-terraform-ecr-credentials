data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_user" "user" {
  name = "${var.team_name}-ecr-system-account"
  path = "/teams/${var.team_name}/"
}

resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:UploadLayerPart",
      "ecr:ListImages",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetRepositoryPolicy",
      "ecr:PutImage",
    ]

    resources = [
      "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/${var.team_name}/*",
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_user_policy" "policy" {
  name   = "ecr-read-write"
  policy = "${data.aws_iam_policy_document.policy.json}"
  user   = "${aws_iam_user.user.name}"
}
