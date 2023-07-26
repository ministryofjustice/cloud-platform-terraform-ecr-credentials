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
<!-- END_TF_DOCS -->

## Tags

Some of the inputs for this module are tags. All infrastructure resources must be tagged to meet the MOJ Technical Guidance on [Documenting owners of infrastructure](https://technical-guidance.service.justice.gov.uk/documentation/standards/documenting-infrastructure-owners.html).

You should use your namespace variables to populate these. See the [Usage](#usage) section for more information.

## Reading Material

- [Cloud Platform user guide](https://user-guide.cloud-platform.service.justice.gov.uk/#cloud-platform-user-guide)
- [Amazon ECR private repositories guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/Repositories.html)
