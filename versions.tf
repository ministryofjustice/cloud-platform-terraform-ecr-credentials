terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    github = {
      source = "integrations/github"
      version = "~> 4.14.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.14"
}
