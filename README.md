# AWS ECR Terraform module

<a href="https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/releases">
  <img src="https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-ecr-credentials/all.svg" alt="Releases" />
</a>

This terraform module will create an ECR repository and IAM credentials to access it; see the [examples/](examples/) dir or `cloud-platform environment ecr create`.

If `github_repositories` is a non-empty list of strings, [github actions
secrets] will be created in those repositories, containing the ECR name, AWS
access key, and AWS secret key.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.27.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.14.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.27.0 |
| <a name="provider_github"></a> [github](#provider\_github) | >= 4.14.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_access_key.key_2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [github_actions_environment_secret.ecr_access_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.ecr_name](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.ecr_secret_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.ecr_url](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_secret.ecr_access_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.ecr_name](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.ecr_secret_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.ecr_url](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [random_id.user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_actions_secret_ecr_access_key"></a> [github\_actions\_secret\_ecr\_access\_key](#input\_github\_actions\_secret\_ecr\_access\_key) | The name of the github actions secret containing the ECR AWS access key | `string` | `"ECR_AWS_ACCESS_KEY_ID"` | no |
| <a name="input_github_actions_secret_ecr_name"></a> [github\_actions\_secret\_ecr\_name](#input\_github\_actions\_secret\_ecr\_name) | The name of the github actions secret containing the ECR name | `string` | `"ECR_NAME"` | no |
| <a name="input_github_actions_secret_ecr_secret_key"></a> [github\_actions\_secret\_ecr\_secret\_key](#input\_github\_actions\_secret\_ecr\_secret\_key) | The name of the github actions secret containing the ECR AWS secret key | `string` | `"ECR_AWS_SECRET_ACCESS_KEY"` | no |
| <a name="input_github_actions_secret_ecr_url"></a> [github\_actions\_secret\_ecr\_url](#input\_github\_actions\_secret\_ecr\_url) | The name of the github actions secret containing the ECR URL | `string` | `"ECR_URL"` | no |
| <a name="input_github_environments"></a> [github\_environments](#input\_github\_environments) | GitHub environment in which to create github actions secrets | `list(string)` | `[]` | no |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | GitHub repositories in which to create github actions secrets | `list(string)` | `[]` | no |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | A lifecycle policy consists of one or more rules that determine which images in a repository should be expired. | `string` | `null` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the repository to be created | `string` | n/a | yes |
| <a name="input_scan_on_push"></a> [scan\_on\_push](#input\_scan\_on\_push) | Whether images are scanned after being pushed to the repository (true) or not (false) | `bool` | `true` | no |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Name of the team creating the credentials | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | Access key id for the credentials |
| <a name="output_repo_arn"></a> [repo\_arn](#output\_repo\_arn) | ECR repository ARN |
| <a name="output_repo_url"></a> [repo\_url](#output\_repo\_url) | ECR repository URL |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | Secret for the new credentials |

<!-- END_TF_DOCS -->
