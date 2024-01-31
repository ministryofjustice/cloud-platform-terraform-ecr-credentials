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

var (
	wntErr bool
)

func TestECRValidateSuccess(t *testing.T) {
	t.Parallel()
	t.Log("Testing ECR module")
	wntErr = false

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-test/success",
	}

	_, err := terraform.InitE(t, terraformOptions)
	if err != nil {
		t.Fatal(err)
	}

	v, err := terraform.ValidateE(t, terraformOptions)
	if err != nil && !wntErr {
		t.Fatalf("Wanted Error: %v\nExpected nil got %v", wntErr, err)

	} else {
		t.Logf("Wanted Error: %v\nExpected nil got %v", wntErr, err)
		t.Log(v)
	}

}

func TestECRValidateFailure(t *testing.T) {
	t.Parallel()
	t.Log("Testing ECR module")
	wntErr = true

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-test/failure",
	}

	_, err := terraform.InitE(t, terraformOptions)
	if err != nil {
		t.Fatal(err)
	}

	v, err := terraform.ValidateE(t, terraformOptions)
	if err != nil && wntErr {
		t.Logf("Wanted Error: %v\nExpected error got %v", wntErr, err)
		t.Log(v)
	} else {
		t.Fatalf("Wanted Error: %v\nExpected error got %v", wntErr, err)
	}
}
