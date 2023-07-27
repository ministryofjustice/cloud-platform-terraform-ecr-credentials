# cloud-platform-terraform-ecr-credentials

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-ecr-credentials/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/releases)

This Terraform module will create an [Amazon ECR private repository](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Repositories.html) for use on the Cloud Platform.

If you're using GitHub as your OIDC provider, this module will automatically create the required variables for authentication in your GitHub repository.

If you're using CircleCI as your OIDC provider, this module will create a Kubernetes ConfigMap in your namespace with your authentication variables to use as environment variables in CircleCI.

This module only supports authentication with GitHub Actions and CircleCI.

## Usage

```hcl
module "container_repository" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials?ref=version" # use the latest release

  # Configuration
  team_name = var.team_name # also used to name the repository
  repo_name = var.namespace
  namespace = var.namespace

  # OIDC configuration
  oidc_providers = ["github"]

  # GitHub configuration
  github_repositories = ["example-repository"]
}
```

See the [examples/](examples/) folder for more information.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 5.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |
| <a name="provider_github"></a> [github](#provider\_github) | >= 5.0.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.canned](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_lifecycle_policy.lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_access_key.key_2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.circleci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.circleci_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.github_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [github_actions_environment_secret.ecr_access_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.ecr_name](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.ecr_role_to_assume](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.ecr_secret_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_secret.ecr_url](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_variable.ecr_region](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_variable) | resource |
| [github_actions_environment_variable.ecr_repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_variable) | resource |
| [github_actions_secret.ecr_access_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.ecr_name](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.ecr_role_to_assume](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.ecr_secret_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.ecr_url](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.ecr_region](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_actions_variable.ecr_repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [kubernetes_config_map_v1.circleci_oidc](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [random_id.oidc](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_id.user](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_openid_connect_provider.circleci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.base](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.circleci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.irsa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_secretsmanager_secret.circleci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.circleci](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name | `string` | n/a | yes |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Area of the MOJ responsible for the service | `string` | n/a | yes |
| <a name="input_canned_lifecycle_policy"></a> [canned\_lifecycle\_policy](#input\_canned\_lifecycle\_policy) | A canned lifecycle policy to remove tagged or untagged images | `map(any)` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | (Optional) Whether the ECR should have deletion protection enabled for non-empty registry. Set this to false if you intend to delete your ECR resource or namespace. NOTE: PR owner has responsibility to ensure that no other environments are sharing this ECR. Defaults to true. | `bool` | `true` | no |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | Environment name | `string` | n/a | yes |
| <a name="input_github_actions_prefix"></a> [github\_actions\_prefix](#input\_github\_actions\_prefix) | String prefix for GitHub Actions variable and secrets key | `string` | `""` | no |
| <a name="input_github_actions_secret_ecr_access_key"></a> [github\_actions\_secret\_ecr\_access\_key](#input\_github\_actions\_secret\_ecr\_access\_key) | The name of the github actions secret containing the ECR AWS access key | `string` | `"ECR_AWS_ACCESS_KEY_ID"` | no |
| <a name="input_github_actions_secret_ecr_name"></a> [github\_actions\_secret\_ecr\_name](#input\_github\_actions\_secret\_ecr\_name) | The name of the github actions secret containing the ECR name | `string` | `"ECR_NAME"` | no |
| <a name="input_github_actions_secret_ecr_secret_key"></a> [github\_actions\_secret\_ecr\_secret\_key](#input\_github\_actions\_secret\_ecr\_secret\_key) | The name of the github actions secret containing the ECR AWS secret key | `string` | `"ECR_AWS_SECRET_ACCESS_KEY"` | no |
| <a name="input_github_actions_secret_ecr_url"></a> [github\_actions\_secret\_ecr\_url](#input\_github\_actions\_secret\_ecr\_url) | The name of the github actions secret containing the ECR URL | `string` | `"ECR_URL"` | no |
| <a name="input_github_environments"></a> [github\_environments](#input\_github\_environments) | GitHub environment in which to create github actions secrets | `list(string)` | `[]` | no |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | GitHub repositories in which to create github actions secrets | `list(string)` | `[]` | no |
| <a name="input_infrastructure_support"></a> [infrastructure\_support](#input\_infrastructure\_support) | The team responsible for managing the infrastructure. Should be of the form <team-name> (<team-email>) | `string` | n/a | yes |
| <a name="input_is_production"></a> [is\_production](#input\_is\_production) | Whether this is used for production or not | `string` | n/a | yes |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | A lifecycle policy consists of one or more rules that determine which images in a repository should be expired. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name | `string` | n/a | yes |
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | OIDC providers for this ECR repository, valid values are "github" or "circleci" | `list(string)` | `[]` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the repository to be created | `string` | n/a | yes |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Team name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | Access key id for the credentials |
| <a name="output_irsa_policy_arn"></a> [irsa\_policy\_arn](#output\_irsa\_policy\_arn) | n/a |
| <a name="output_repo_arn"></a> [repo\_arn](#output\_repo\_arn) | ECR repository ARN |
| <a name="output_repo_url"></a> [repo\_url](#output\_repo\_url) | ECR repository URL |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | Secret for the new credentials |
<!-- END_TF_DOCS -->

## Tags

Some of the inputs for this module are tags. All infrastructure resources must be tagged to meet the MOJ Technical Guidance on [Documenting owners of infrastructure](https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html).

You should use your namespace variables to populate these. See the [Usage](#usage) section for more information.

## Reading Material

- [Cloud Platform user guide](https://user-guide.cloud-platform.service.justice.gov.uk/#cloud-platform-user-guide)
- [Amazon ECR private repositories guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Repositories.html)
