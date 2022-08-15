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
| terraform | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| irsa_vpc_cni | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 4.6.0 |

## Resources

| Name |
|------|
| [aws_eks_addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| addon\_coredns\_version | Version for addon\_coredns\_version | `string` | `"v1.8.4-eksbuild.1"` | no |
| addon\_create\_coredns | Create coredns addon | `bool` | `true` | no |
| addon\_create\_kube\_proxy | Create kube\_proxy addon | `bool` | `true` | no |
| addon\_create\_vpc\_cni | Create vpc\_cni addon | `bool` | `true` | no |
| addon\_kube\_proxy\_version | Version for addon\_kube\_proxy\_version | `string` | `"v1.21.2-eksbuild.2"` | no |
| addon\_tags | Cluster addon tags | `map(string)` | `{}` | no |
| addon\_vpc\_cni\_version | Version for addon\_create\_vpc\_cni | `string` | `"v1.9.3-eksbuild.1"` | no |
| cluster\_name | Kubernetes cluster name - used to name (id) the auth0 resources | `any` | n/a | yes |
| cluster\_oidc\_issuer\_url | Used to create the IAM OIDC role | `string` | `""` | no |
| eks\_cluster\_id | trigger for null resource using eks\_cluster\_id | `any` | n/a | yes |

## Outputs

No output.

<!--- END_TF_DOCS --->