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
    namespace = "<NAMESPACE>"
  }

  data = {
    access_key_id     = module.example_team_ecr_credentials.access_key_id
    secret_access_key = module.example_team_ecr_credentials.secret_access_key
    repo_arn          = module.example_team_ecr_credentials.repo_arn
    repo_url          = module.example_team_ecr_credentials.repo_url
  }
}


/*
#############################################SLACK NOTIFIATIONS OF ECR SCAN RESULTS########################

To send notifications to slack of the ECR image scanned results, you may insert the following lambda module that creates the slack lambda function and the event bridge. 

The event bridge will be triggered every time there is a scan completed for your ECR repo. The eventbridge executes the lambda function which then interacts with slack. A notification containing the scanned result will then be sent to your slack channel as per the slack token you specify.

The lambda function dynamically consumes the slack_token and ecr_repo during its creation time. The slack_token and ecr_repo must be stored as a kubernetes secret, which you must create as follows:

This secret needs to have the following two keys:

Key 1: repo (without the pre-fix e.g if the url is 754256621582.dkr.ecr.eu-west-2.amazonaws.com/webops/webops-ecr1:rails, then in this case you need to supply 'webops/webops-ecr1')
Key 2: token

Below is a sample kubernetes secret yaml you can use to create the secret containing the slack token and ECR repo: 

apiVersion: v1
kind: Secret
metadata:
  name: <SLACK_SECRET_NAME>
  namespace: <NAMESPACE>
data:
  repo: <ECR_REPO_BASE64_ENCODED>
  token: <SLACK_TOKEN_BASE64_ENDCODED>

Note that the <ECR_REPO_BASE64_ENCODED> and <SLACK_TOKEN_BASE64_ENDCODED> must be encoded as base64.
e.g 'echo -n <SLACK_TOKEN> | base64'

As this file will contain the slack token it is important that it is encyrpted within a private repo that has git-encrypt. Also the file must reside within your own team's private repo and not a repo that is shared between teams such as the 'cloud-platform-environments'.

Save the above secret yaml with the desired name and create the secret as follows: 

kubectl create -f <SLACK_SECRET_FILE_NAME>

Lastly, after you have created your kubernetes slack secret as above, move the following lambda module outside the comments section so that it is created alongside your ECR resource. 

module "ecr_scan_lambda" {

  source                     = "github.com/ministryofjustice/cloud-platform-terraform-lambda-ecr-slack?ref=v1.0"
  function_name              = "example-function-name"
  handler                    = "lambda_ecr-scan-slack.lambda_handler"
  lambda_role_name           = "example-team-role-name"
  lambda_policy_name         = "example-team-policy-name"
  slack_secret               = "<SLACK_SECRET_NAME>"
  namespace                  = "<NAMESPACE>"

}

*/

