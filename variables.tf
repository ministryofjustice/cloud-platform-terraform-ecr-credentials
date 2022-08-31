variable "repo_name" {
  description = "Name of the repository to be created"
  type        = string
}

variable "team_name" {
  description = "Name of the team creating the credentials"
  type        = string
}

variable "scan_on_push" {
  default     = true
  description = "Whether images are scanned after being pushed to the repository (true) or not (false)"
  type        = bool
}

variable "github_repositories" {
  description = "GitHub repositories in which to create github actions secrets"
  default     = []
  type        = list(string)
}

variable "github_environments" {
  description = "GitHub environment in which to create github actions secrets"
  type        = list(string)
  default     = []
}

variable "github_actions_secret_ecr_name" {
  description = "The name of the github actions secret containing the ECR name"
  default     = "ECR_NAME"
  type        = string
}

variable "github_actions_secret_ecr_url" {
  description = "The name of the github actions secret containing the ECR URL"
  default     = "ECR_URL"
  type        = string
}

variable "github_actions_secret_ecr_access_key" {
  description = "The name of the github actions secret containing the ECR AWS access key"
  default     = "ECR_AWS_ACCESS_KEY_ID"
  type        = string
}

variable "github_actions_secret_ecr_secret_key" {
  description = "The name of the github actions secret containing the ECR AWS secret key"
  default     = "ECR_AWS_SECRET_ACCESS_KEY"
  type        = string
}

# Lifecycle policy
variable "lifecycle_policy" {
  description = "A lifecycle policy consists of one or more rules that determine which images in a repository should be expired."
  type        = string
  default     = null
}
