provider "aws" {
  region = "eu-west-2"
}

module "ecr" {
  source = "../.."

  # Configuration
  repo_name = var.namespace

  # Tags
  business_unit          = var.business_unit
  application            = var.application
  is_production          = var.is_production
  team_name              = var.team_name # also used for naming the container repository
  namespace              = var.namespace # also used for creating a Kubernetes ConfigMap
  environment_name       = var.environment
  infrastructure_support = var.infrastructure_support
}
