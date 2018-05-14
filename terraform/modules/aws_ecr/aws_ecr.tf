data "aws_iam_user" "user" {
  user_name = "${var.user_name}"
}

resource "aws_iam_policy" "policy" {
  name        = "${var.user_name}_ecr_policy"
  description = "ecr policy for user ${var.user_name}"

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
            "Resource": "arn:aws:ecr:eu-west-1:${var.account_id}:repository/${var.repo_name}"
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
    user       = "${data.aws_iam_user.user.user_name}"
    policy_arn = "${aws_iam_policy.policy.arn}"
}
