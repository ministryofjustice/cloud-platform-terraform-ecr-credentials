output "repo_arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.repo.arn
}

output "repo_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.repo.repository_url
}

output "irsa_policy_arn" {
  description = "IAM policy ARN for access to the container repository"
  value       = aws_iam_policy.irsa.arn
}
