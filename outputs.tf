output "access_key_id" {
  description = "Access key id for the credentials"
  value       = "${aws_iam_access_key.key.id}"
}

output "secret_access_key" {
  description = "Secret for the new credentials"
  value       = "${aws_iam_access_key.key.secret}"
}

output "user_name" {
  description = "User name for the new credentials"
  value       = "${aws_iam_user.user.name}"
}

output "repo_arn" {
  description = "ECR repository ARN"
  value       = "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/${var.team_name}/${var.repo_name}"
}
