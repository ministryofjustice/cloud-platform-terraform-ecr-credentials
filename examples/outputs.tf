output "access_key_id" {
  description = "Access key id for the credentials"
  value       = "${module.example_team_ecr_credentials.access_key_id}"
}

output "secret_access_key" {
  description = "Secret for the new credentials"
  value       = "${module.example_team_ecr_credentials.secret_access_key}"
}

output "repo_arn" {
  description = "ECR repo ARN"
  value       = "${module.example_team_ecr_credentials.repo_arn}"
}

output "repo_url" {
  description = "ECR repo URL"
  value       = "${module.example_team_ecr_credentials.repo_url}"
}
