output "policy_arn" {
  description = "ARN for the new policy"
  value       = "${module.aws_ecr.policy_arn}"
}

output "access_key_id" {
  description = "Access key id for the credentials"
  value       = "${module.aws_ecr.access_key_id}"
}

output "secret" {
  description = "Secret for the new credentials"
  value       = "${module.aws_ecr.secret}"
}

output "user_name" {
  description = "User name for the new credentials"
  value       = "${module.aws_ecr.user_name}"
}
