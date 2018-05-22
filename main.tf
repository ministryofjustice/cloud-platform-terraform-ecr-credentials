data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_user" "user" {
  name = "${var.team_name}-ecr-system-account"
  path = "/teams/${var.team_name}/"
}

resource "aws_iam_access_key" "key" {
  user = "${aws_iam_user.user.name}"
}

resource "aws_iam_policy" "policy" {
  name        = "${var.team_name}-ecr-read-write"
  path        = "/teams/${var.team_name}/"
  description = "ECR policy for team ${var.team_name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
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
                "ecr:PutImage"
            ],
            "Resource": "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/${var.team_name}/${var.repo_name}"
        },
        {
            "Effect": "Allow",
            "Action": "ecr:GetAuthorizationToken",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "policy-attachment" {
    user       = "${aws_iam_user.user.name}"
    policy_arn = "${aws_iam_policy.policy.arn}"
}
