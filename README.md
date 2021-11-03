# AWS ECR Terraform module

<a href="https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/releases">
  <img src="https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-ecr-credentials/all.svg" alt="Releases" />
</a>

This terraform module will create an ECR repository and IAM credentials to access it; see the [examples/](examples/) dir or `cloud-platform environment ecr create`.

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
| github_actions_secret_ecr_url | Name of the github actions secret containing the ECR URL | ECR_URL | no |
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
