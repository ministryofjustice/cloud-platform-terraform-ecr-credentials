variable "repo_name" {
  description = "Name of the repository to be created"
  type        = string
}

variable "team_name" {
  description = "Name of the team creating the credentials"
  type        = string
}

variable "namespace" {
  description = "Namespace name"
  type        = string
  default     = null
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

variable "canned_lifecycle_policy" {
  description = "A canned lifecycle policy to remove tagged or untagged images"
  type        = map(any)
  default     = null
}

########
# OIDC #
########
variable "oidc_providers" {
  description = "OIDC providers for this ECR repository, valid values are \"github\" or \"circleci\""
  type        = list(string)
  default     = []
}

variable "github_actions_prefix" {
  description = "String prefix for GitHub Actions variable and secrets key"
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "(Optional) Whether the ECR should have deletion protection enabled for non-empty registry. Set this to false if you intend to delete your ECR resource or namespace. NOTE: PR owner has responsibility to ensure that no other environments are sharing this ECR. Defaults to true."
  type        = bool
  default     = true
}
