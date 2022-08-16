# AWS ECR Terraform module

<a href="https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/releases">
  <img src="https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-ecr-credentials/all.svg" alt="Releases" />
</a>

This terraform module will create an ECR repository and IAM credentials to access it; see the [examples/](examples/) dir or `cloud-platform environment ecr create`.

If `github_repositories` is a non-empty list of strings, [github actions
secrets] will be created in those repositories, containing the ECR name, AWS
access key, and AWS secret key.

## Slack notifications for ECR scan results

To send notifications to slack of the ECR image scan results, you may insert the following lambda module that creates the slack lambda function and the event bridge.

The event bridge will be triggered every time there is a scan completed for your ECR repo. The event bridge executes the lambda function which then interacts with slack. A notification containing the scan result will then be sent to your slack channel as per the slack token you specify.

The lambda function incorporates the slack token and ECR repository when it is created. The slack_token and ECR repository must be stored as a kubernetes secret, which you must create as follows:

This secret needs to have the following two keys:

Key 1: repo (without the prefix e.g if the url is `754256621582.dkr.ecr.eu-west-2.amazonaws.com/webops/webops-ecr1:rails`, then in this case you need to supply `webops/webops-ecr1`)

Key 2: token

Below is a sample kubernetes secret yaml you can use to create the secret containing the slack token and ECR repo:
```
apiVersion: v1
kind: Secret
metadata:
  name: <SLACK_SECRET_NAME>
  namespace: <NAMESPACE>
data:
  repo: <ECR_REPO_BASE64_ENCODED>
  token: <SLACK_TOKEN_BASE64_ENDCODED>
```

Note that the <ECR_REPO_BASE64_ENCODED> and <SLACK_TOKEN_BASE64_ENDCODED> must be encoded as base64 (`echo -n <SLACK_TOKEN> | base64`)

As this file will contain the slack token it is important that it is encyrpted within the repo that has git-encrypt. Also the file must reside within your own team's repo and not a repo that is shared between teams such as the 'cloud-platform-environments'.

Save the above secret yaml with the desired name and create the secret with `kubectl create -f <SLACK_SECRET_FILE_NAME>`

Lastly, after you have created your kubernetes slack secret as above, add the following lambda module in your `ecr.tf`:
```
module "ecr_scan_lambda" {
  source                     = "github.com/ministryofjustice/cloud-platform-terraform-lambda-ecr-slack?ref=v1.0"
  # Function name can be as desired but unique, ideally prefixed with team name and the purpose of the function e.g 'webops_ecr_scan_function'
  function_name              = "example-function-name"
  # Lambda role name as desired but unique ideally prefixed with team name e.g webops_ecr_scan_role
  lambda_role_name           = "example-team-role-name"
  # Lambda policy name as desired but unique ideally prefixed with team name e.g webops_ecr_scan_policy
  lambda_policy_name         = "example-team-policy-name"
  slack_secret               = "<SLACK_SECRET_NAME>"
  namespace                  = var.namespace
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.14.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0.0 |
| <a name="provider_github"></a> [github](#provider\_github) | >= 4.14.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.repo](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_iam_access_key.key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
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

<!--- END_TF_DOCS --->