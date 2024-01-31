variable "business_unit" {
  default = "Platforms"
}

variable "application" {
  default = "cloud-platform-terraform-ecr-credentials example module"
}

variable "is_production" {
  default = "false"
}

variable "team_name" {
  default = "webops"
}

variable "namespace" {
  default = "cloud-platform-terraform-ecr-credentials-example-module"
}

variable "environment" {
  default = "non-production"
}

variable "infrastructure_support" {
  default = "Cloud Platform"
}

variable "github_owner" {
  description = "Required by the GitHub terraform provider"
  default     = "ministryofjustice"
}

variable "github_token" {
  description = "Required by the GitHub terraform provider"
  default     = ""
}