# example ECR Credentials

Configuration in this directory creates example ECR repository and credentials.

This example outputs user name and secrets for the new credentials.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.

## Outputs

| Name | Description |
|------|-------------|
| policy_arn | ARN for the new policy |
| access_key_id | Access key id for the new user |
| secret | Secret for the new user |
| user_name | User name for the new credentials |
