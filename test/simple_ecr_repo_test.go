package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/magiconair/properties/assert"
)

func TestSimpleEcrRepo(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./unit-test",
	})

	// we don't need this for dummy ECR in localstack
	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	repoArn := terraform.Output(t, terraformOptions, "repo_arn")
	repoUrl := terraform.Output(t, terraformOptions, "repo_url")

	assert.Equal(t, "\"arn:aws:ecr:eu-west-2:000000000000:repository/cloud-platform/ecr-repo-unit-test\"", repoArn)
	assert.Equal(t, "\"localhost:4510/cloud-platform/ecr-repo-unit-test\"", repoUrl)
}
