variable "repo_name" {
}

variable "team_name" {
}

variable "aws_region" {
  description = "Region into which the resource will be created."
  default     = "eu-west-2"
}

variable "scan_on_push" {
  default = true
}

variable "github_repositories" {
  description = "GitHub repositories in which to create github actions secrets"
  default     = []
}

variable "github_actions_secret_ecr_name" {
  description = "The name of the github actions secret containing the ECR name"
  default     = "ECR_NAME"
}

variable "github_actions_secret_ecr_access_key" {
  description = "The name of the github actions secret containing the ECR AWS access key"
  default     = "ECR_AWS_ACCESS_KEY_ID"
}

variable "github_actions_secret_ecr_secret_key" {
  description = "The name of the github actions secret containing the ECR AWS secret key"
  default     = "ECR_AWS_SECRET_ACCESS_KEY"
}
