provider "aws" {
  region = "eu-west-1"
}

module "aws_ecr" {
#  source = "git@github.com:ministryofjustice/cloud-platform-terraform-ecr-credentials.git"
  source = "../"

  repo_name = "test-repo"
  team_name = "best-team"
}
