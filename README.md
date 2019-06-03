# AWS ECR Terraform module

<a href="https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/releases">
  <img src="https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-ecr-credentials/all.svg" alt="Releases" />
</a>

This terraform module will create an ECR repository and IAM credentials to access it.

## Usage

**This module will create the resources in the region of the providers specified in the `providers` input.**

**Be sure to create the relevant providers, see example/main.tf**

**From module version 3.2, this replaces the use of the `aws_region`.**

```hcl
module "best_team_ecr_credentials" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials"

  repo_name = "test-repo"
  team_name = "best-team"

  # This is a new input
  providers = {
    aws = "aws.london"
  }
}
```

Note: From version 3.0 of this module, The AWS region  will default to eu-west-2 (London). If you want to deploy to eu-west-1(Ireland), edit the above accordingly.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| repo_name | name of the repository to be created | string | - | yes |
| team_name | name of the team creating the credentials | string | - | yes |
| aws_region | region into which the resource will be created | string | eu-west-2 | no
| providers | provider creating resources | arrays of string | default provider | no


## Outputs

| Name | Description |
|------|-------------|
| access_key_id | Access key id for the new user |
| secret_access_key | Secret for the new user |
| repo_arn | ECR repository ARN |
| repo_url | ECR repository URL |
