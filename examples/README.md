# Example AWS ECR Repo Credentials configuration

Configuration in this directory creates example ECR repository and credentials.

This example is designed to be used in the [cloud-platform-environments](https://github.com/ministryofjustice/cloud-platform-environments/) repository.

The output will be in a kubernetes `Secret`, which includes the values of `access_key_id`, `secret_access_key`, `repo_arn` and `repo_url`.

## Usage

In your namespace's path in the [cloud-platform-environments](https://github.com/ministryofjustice/cloud-platform-environments/) repository, create a directory called `resources` (if you have not created one already) and refer to the contents of [main.tf](main.tf) to define the module properties. Make sure to change placeholder values to what is appropriate and refer to the top-level README file in this repository for extra variables that you can use to further customise your resource.

If you do not have a `main.tf` file already, you can use the one provided here, with any necessary changes. If you already have a `main.tf` file in your `resources` directory, you can ignore this one.

Copy the `ecr.tf` file to your `resources` directory, and make any required changes.

Commit your changes to a branch and raise a pull request. Once approved, you can merge and the changes will be applied. Shortly after, you should be able to access the `Secret` on kubernetes and acccess the resources. The generated key allows access to all the Docker repositories tagged with the team's name. You might want to refer to the [documentation on Secrets](https://kubernetes.io/docs/concepts/configuration/secret/).

## From your laptop

Read the AWS key/secret out of your namespace with

```
kubectl --context=example-team-context --namespace example-app-ns get secret example-team-ecr-credentials-output -o json

```

With the AWS_ env vars exported, the usual ECR command apply, restricted by IAM policy to the namespace matching your Github team's slug:

```
eval $(aws ecr get-login --no-include-email)

aws ecr describe-repositories

docker tag <localimage> <accountid>.dkr.ecr.eu-west-1.amazonaws.com/example-team/example-repo:nginx

docker push <accountid>.dkr.ecr.eu-west-1.amazonaws.com/example-team/example-repo:nginx

aws ecr batch-delete-image --repository-name example-team/example-repo --image-ids imageTag=nginx

```
