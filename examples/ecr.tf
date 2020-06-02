/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */
module "example_team_ecr_credentials" {
  source    = "github.com/ministryofjustice/cloud-platform-terraform-ecr-credentials?ref=4.0"
  repo_name = "example-module"
  team_name = "example-team"
  # By default scan_on_push is set to true. To disable set it to false as below:
  #scan_on_push = "false"  

  providers = {
    aws = aws.london
  }
}

resource "kubernetes_secret" "example_team_ecr_credentials" {
  metadata {
    name      = "example-team-ecr-credentials-output"
    namespace = "my-namespace"
  }

  data = {
    access_key_id     = module.example_team_ecr_credentials.access_key_id
    secret_access_key = module.example_team_ecr_credentials.secret_access_key
    repo_arn          = module.example_team_ecr_credentials.repo_arn
    repo_url          = module.example_team_ecr_credentials.repo_url
  }
}

########SLACK NOTIFIATIONS OF ECR SCAN RESULTS########################

#To send notifications to slack of the ECR scanned results, you may insert the following two modules, one creates the lambda function.
# and the other creates the even bridge that forwards the result details to the lambda function

# SLACK KUBERNETES SECRET 

# Note that you will need to create a kubernetes secret that contains the slack token and the ECR repo.

# The lambda needs the slack token and repo corresponding to the channel. The keys are set as environment variables. This secret needs
# be created with the following keys:

#Key 1: repo (without the pre-fix e.g if the url is 754256621582.dkr.ecr.eu-west-2.amazonaws.com/webops/webops-ecr1:rails, then in this case you need to supply 'webops/webops-ecr1')
#Key 2: token

# You can run the following kubernets example command to the create the secret: 

# kubectl create secret generic <SECRET_NAME> --from-literal=token=<SLACK_TOKEN> --from-literal=repo=<ECR_REPO> -n <NAMESPACE>

data "kubernetes_secret" "slack_cred" {
  metadata {
    name      = "my-slack-secret-name"
    namespace = "my-space"
  }
}

module "ecr_scan_lambda" {

  source                     = "github.com/ministryofjustice/cloud-platform-terraform-lambda-ecr-slack?ref=v1.0"
  function_name              = "example-function-name"
  handler                    = "lambda_ecr-scan-slack.lambda_handler"
  lambda_role_name           = "example-team-role-name"
  lambda_policy_name         = "example-team-policy-name"
  slack_token                = "${data.kubernetes_secret.slack_cred.data["token"]}"
  ecr_repo                   = "${data.kubernetes_secret.slack_cred.data["repo"]}"

}