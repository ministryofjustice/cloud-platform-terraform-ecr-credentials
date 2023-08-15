#################
# Configuration #
#################
variable "repo_name" {
  description = "Name of the repository to be created"
  type        = string
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

########
# Tags #
########
variable "business_unit" {
  description = "Area of the MOJ responsible for the service"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "is_production" {
  description = "Whether this is used for production or not"
  type        = string
}

variable "team_name" {
  description = "Team name"
  type        = string
}

variable "namespace" {
  description = "Namespace name"
  type        = string
}

variable "environment_name" {
  description = "Environment name"
  type        = string
}

variable "infrastructure_support" {
  description = "The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>)"
  type        = string
}
