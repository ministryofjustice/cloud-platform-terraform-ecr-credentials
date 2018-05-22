output "policy_arn" {
  description = "ARN for the new policy"
  value = "${aws_iam_policy.policy.arn}"
}

output "access_key_id" {
  description = "Access key id for the credentials"
  value = "${aws_iam_access_key.key.id}"
}

output "secret" {
  description = "Secret for the new credentials"
  value = "${aws_iam_access_key.key.secret}"
}

output "user_name" {
  description = "User name for the new credentials"
  value = "${aws_iam_user.user.name}"
}
