<!-- BEGIN_TF_DOCS -->
# Module Terraform SQS Lambda Easy-Lamb

Allow use to easily deploy SQS lambda with Terraform.

## Features

- Deploy AWS Lambda
- Associate SQS to Lambda

## Usage

```hcl
module "easy-lamb-sqs-lambda" {
  source = "git::https://github.com/easy-lamb/easy-lamb-terraform?depth=1&ref=main"
  project_name = "easy-lamb-api"
  environment  = "prod"
  function = {}
}

```

# Generated documentation

This documentation is generated using terraform-docs. Please do not edit it manually.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ../lambda | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_event_source_mapping.sqs_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping) | resource |
| [aws_sqs_queue.sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_function"></a> [function](#input\_function) | function = {<br/>    name = "the name of the function"<br/>    description = "The description of the function"<br/>    memory = "The amount of memory to allocate to the function (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"<br/>    timeout = "The amount of time the function has to run (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)<br/>    source = "The path to the source code for the function (ex: dist/hello)"<br/>    handler = "The name of the handler function in the source code (ex: fileName.functionName)"<br/>    runtime = "The runtime to use for the function (https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime)"<br/>    log\_retention = "The number of days to retain logs for"<br/>    environment = "The environment variables to set for the function"<br/>    policies = "The policies to attach to the function"<br/>    assume\_roles = "The roles to assume for the function"<br/>    http\_path = "The HTTP path to bind to the function (ex: /hello)"<br/>    http\_method = "The HTTP method to bind to the function (ex: GET)"<br/>    authorizer\_name = "The name of the authorizer"<br/>    override\_env = "Read .env file and add values to environment"<br/>  } | <pre>object({<br/>    name          = string<br/>    memory        = number<br/>    timeout       = number<br/>    source        = string<br/>    handler       = string<br/>    runtime       = string<br/>    tracing       = optional(bool, true)<br/>    description   = optional(string)<br/>    log_retention = optional(number, 3)<br/>    environment   = optional(map(string), {})<br/>    policies      = optional(map(string), {})<br/>    assume_roles  = optional(list(string), [])<br/>    override_env  = optional(bool, false)<br/>  })</pre> | n/a | yes |
| <a name="input_output_zip_dir"></a> [output\_zip\_dir](#input\_output\_zip\_dir) | The directory to output the zip files to | `string` | `"dist"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sqs_queue_url"></a> [sqs\_queue\_url](#output\_sqs\_queue\_url) | The URL of the SQS queue |
<!-- END_TF_DOCS -->