<!-- BEGIN_TF_DOCS -->
# Module Terraform IOT Lambda Easy-Lamb

Allow use to easily deploy IOT lambda with Terraform.

## Features

- Deploy AWS Lambda
- Associate MQTT SQL to Lambda

## Usage

```hcl
module "easy-lamb-iot-lambda" {
  source = "URL"
  version = "LAST_RELEASE_VERSION"
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
| [aws_iot_topic_rule.iot_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_topic_rule) | resource |
| [aws_lambda_permission.allow_iot_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_function"></a> [function](#input\_function) | function = {<br/>    name = "the name of the function"<br/>    description = "The description of the function"<br/>    memory = "The amount of memory to allocate to the function (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"<br/>    timeout = "The amount of time the function has to run (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)<br/>    source = "The path to the source code for the function (ex: dist/hello)"<br/>    handler = "The name of the handler function in the source code (ex: fileName.functionName)"<br/>    runtime = "The runtime to use for the function (https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime)"<br/>    log\_retention = "The number of days to retain logs for"<br/>    environment = "The environment variables to set for the function"<br/>    policies = "The policies to attach to the function"<br/>    assume\_roles = "The roles to assume for the function"<br/>    mqtt\_sql = "The MQTT SQL to trigger the lambda function"<br/>    override\_env = "Read .env file and add values to environment"<br/>    layers = "The layers to attach to the function"<br/>    architectures = "The architectures to build the function for"<br/>  } | <pre>object({<br/>    name          = string<br/>    memory        = number<br/>    timeout       = number<br/>    source        = string<br/>    handler       = string<br/>    runtime       = string<br/>    tracing       = optional(bool, true)<br/>    description   = optional(string)<br/>    log_retention = optional(number, 3)<br/>    environment   = optional(map(string), {})<br/>    policies      = optional(map(string), {})<br/>    assume_roles  = optional(list(string), [])<br/>    mqtt_sql      = string<br/>    override_env  = optional(bool, false)<br/>    layers        = optional(list(string), [])<br/>    architectures = optional(list(string), ["x86_64"])<br/>  })</pre> | n/a | yes |
| <a name="input_output_zip_dir"></a> [output\_zip\_dir](#input\_output\_zip\_dir) | The directory to output the zip files to | `string` | `"dist"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project | `string` | n/a | yes |
<!-- END_TF_DOCS -->