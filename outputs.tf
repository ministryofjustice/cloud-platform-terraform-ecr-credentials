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
  value       = "${aws_ecr_repository.repo.arn}"
}

output "repo_url" {
  description = "ECR repository URL"
  value       = "${aws_ecr_repository.repo.repository_url}"
}
