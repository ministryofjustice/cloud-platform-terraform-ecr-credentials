variable "repo_name" {
}

variable "team_name" {
}

variable "enable_scanning_on_push" {
  default = true
}

variable "aws_region" {
  description = "Region into which the resource will be created."
  default     = "eu-west-2"
}

