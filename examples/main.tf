provider "aws" {
  region = "eu-west-1"
}

module "example_team_ecr_credentials" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials?ref=master"

  repo_name = "example-repo"
  team_name = "example-team"
}
