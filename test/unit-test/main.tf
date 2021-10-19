terraform {
  required_version = ">= 0.14"
}

provider "aws" {
  region                      = "eu-west-2"
}

module "ecr" {
  source = "../.."

  repo_name = "ecr-repo-unit-test"
  team_name = "cloud-platform"
}
