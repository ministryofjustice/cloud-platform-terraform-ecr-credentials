# Terraform module testing

We use terratest to execute unit/integration tests in our terraform modules. Every time someone opens a PR there is a github action which executes the tests within `cloud-platform-ephemeral-test` AWS account. 

# Executing the tests locally

To execute the tests locally:

```
$ go test -v
=== RUN   TestSimpleEcrRepo                                                           
=== PAUSE TestSimpleEcrRepo                                                                                                                                                  
=== CONT  TestSimpleEcrRepo                                                                                                                                                  
TestSimpleEcrRepo 2021-01-26T15:41:44Z retry.go:91: terraform [init -upgrade=false]                                                                                          
TestSimpleEcrRepo 2021-01-26T15:41:44Z logger.go:66: Running command terraform with args [init -upgrade=false]                                                               
TestSimpleEcrRepo 2021-01-26T15:41:44Z logger.go:66: Initializing modules...          
...
...
...
...

```
