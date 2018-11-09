output "access_key_id" {
  description = "Access key id for the credentials"
  value       = "${aws_iam_access_key.key.id}"
}

output "secret_access_key" {
  description = "Secret for the new credentials"
  value       = "${aws_iam_access_key.key.secret}"
}

output "repo_arn" {
  description = "ECR repository ARN"
  value       = "${format("arn:aws:ecr:eu-west-1:%s:repository/%s/%s", var.account_id, var.team_name, var.repo_name)}"
}

output "repo_url" {
  description = "ECR repository URL"
  value       = "${format("%s.dkr.ecr.eu-west-1.amazonaws.com/repository/%s/%s", var.account_id, var.team_name, var.repo_name)}"
}
