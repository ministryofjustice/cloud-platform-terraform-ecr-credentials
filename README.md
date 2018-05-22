# AWS ECR Terraform module

Terraform module which creates ECR credentials and repository on AWS.

## Usage

```hcl
module "best_team_ecr_credentials" {
  source = "git@github.com:ministryofjustice/cloud-platform-terraform-ecr-credentials.git"

  repo_name = "test-repo"
  team_name = "best-team"
}
```

## Examples

* [Basic EC2 instance](https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/tree/master/examples)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| repo_name | name of the repository to be created | string | - | yes |
| team_name | name of the team creating the credentials | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy_arn | ARN for the new policy |
| access_key_id | Access key id for the new user |
| secret | Secret for the new user |
| user_name | User name for the new credentials |
| repo_arn | ECR repository ARN |
