provider "aws" {
  region = "eu-west-2"
}

module "ecr" {
  source = "../.."

  repo_name = "ecr-repo-unit-test"
  team_name = "cloud-platform"
  namespace = "cloud-platform"
}
