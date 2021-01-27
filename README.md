# AWS ECR Terraform module

<a href="https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/releases">
  <img src="https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-ecr-credentials/all.svg" alt="Releases" />
</a>

This terraform module will create an ECR repository and IAM credentials to access it.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| repo_name | name of the repository to be created | string | - | yes |
| team_name | name of the team creating the credentials | string | - | yes |
| aws_region | region into which the resource will be created | string | eu-west-2 | no |
| providers | provider creating resources | arrays of string | default provider | no |


## Outputs

| Name | Description |
|------|-------------|
| access_key_id | Access key id for the new user |
| secret_access_key | Secret for the new user |
| repo_arn | ECR repository ARN |
| repo_url | ECR repository URL |
