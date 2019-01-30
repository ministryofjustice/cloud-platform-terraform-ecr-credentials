variable "repo_name" {}

variable "team_name" {}

variable "enable_policy" {
  description = "Sets a ECR lifecycle policy to delete every image after count 900. Default is true."
  default     = true
}
