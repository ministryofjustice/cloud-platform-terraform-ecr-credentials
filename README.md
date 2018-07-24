# AWS ECR Terraform module

Terraform module which creates ECR credentials and repository on AWS.

## Usage

```hcl
module "best_team_ecr_credentials" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials?ref=master"

  repo_name = "test-repo"
  team_name = "best-team"
}
```

[Example](https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/tree/master/examples)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| repo_name | name of the repository to be created | string | - | yes |
| team_name | name of the team creating the credentials | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| access_key_id | Access key id for the new user |
| secret_access_key | Secret for the new user |
| repo_arn | ECR repository ARN |
| repo_url | ECR repository URL |
