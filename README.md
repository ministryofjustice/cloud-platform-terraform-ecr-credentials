# cloud-platform-terraform-ecr-credentials

<a href="https://github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials/releases">
  <img src="https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-ecr-credentials/all.svg" alt="Releases" />
</a>

This Terraform module will create an AWS ECR repository for use on the Cloud Platform.

If you're using GitHub as your OIDC provider, it will automatically create the required variables for authentication in your GitHub repository.

If you're using CircleCI as your OIDC provider, it will create a Kubernetes ConfigMap with your authentication variables to use as environment variables in CircleCI.

This module only supports authentication with GitHub Actions and CircleCI.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
