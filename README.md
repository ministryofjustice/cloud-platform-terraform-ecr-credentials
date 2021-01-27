# AWS ECR Terraform module

<a href="https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/releases">
  <img src="https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-ecr-credentials/all.svg" alt="Releases" />
</a>

This terraform module will create an ECR repository and IAM credentials to access it.

If `github_repositories` is a non-empty list of strings, [github actions
secrets] will be created in those repositories, containing the ECR name, AWS
access key, and AWS secret key.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| repo_name | name of the repository to be created | string | - | yes |
| team_name | name of the team creating the credentials | string | - | yes |
| aws_region | region into which the resource will be created | string | eu-west-2 | no |
| providers | provider creating resources | arrays of string | default provider | no |
| github_repositories | List of repositories in which to create github actions secrets | list of strings | no |
| github_actions_secret_ecr_name | Name of the github actions secret containing the ECR name | ECR_NAME | no |
| github_actions_secret_ecr_access_key | Name of the github actions secret containing the ECR AWS access key | ECR_AWS_ACCESS_KEY_ID | no |
| github_actions_secret_ecr_secret_key | Name of the github actions secret containing the ECR AWS secret key | ECR_AWS_SECRET_ACCESS_KEY | no |

## Outputs

| Name | Description |
|------|-------------|
| access_key_id | Access key id for the new user |
| secret_access_key | Secret for the new user |
| repo_arn | ECR repository ARN |
| repo_url | ECR repository URL |

[github actions secrets]: https://docs.github.com/en/actions/reference/encrypted-secrets
