output "policy_arn" {
  description = "ARN for the new policy"
  value       = "${module.example_team_ecr_credentials.policy_arn}"
}

output "access_key_id" {
  description = "Access key id for the credentials"
  value       = "${module.example_team_ecr_credentials.access_key_id}"
}

output "secret_access_key" {
  description = "Secret for the new credentials"
  value       = "${module.example_team_ecr_credentials.secret_access_key}"
}

output "user_name" {
  description = "User name for the new credentials"
  value       = "${module.example_team_ecr_credentials.user_name}"
}

output "repo_arn" {
  description = "ECR repo ARN"
  value       = "${module.example_team_ecr_credentials.repo_arn}"
}
