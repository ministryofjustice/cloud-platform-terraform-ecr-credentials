package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/magiconair/properties/assert"
)

func TestSimpleEcrRepo(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/unit-test",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	repoArn := terraform.Output(t, terraformOptions, "repo_arn")
	repoUrl := terraform.Output(t, terraformOptions, "repo_url")
	assert.Equal(t, "arn:aws:ecr:eu-west-2:754256621582:repository/cloud-platform/ecr-repo-unit-test", repoArn)
	assert.Equal(t, "754256621582.dkr.ecr.eu-west-2.amazonaws.com/cloud-platform/ecr-repo-unit-test", repoUrl)
}
