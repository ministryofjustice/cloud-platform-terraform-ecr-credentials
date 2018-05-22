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
      "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.team_name}/*",
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

resource "aws_iam_policy" "policy" {
  name        = "${var.team_name}-ecr-read-write"
  path        = "/teams/${var.team_name}/"
  policy      = "${data.aws_iam_policy_document.policy.json}"
  description = "ECR policy for team ${var.team_name}"
}

resource "aws_iam_user_policy_attachment" "policy-attachment" {
  user       = "${aws_iam_user.user.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}
