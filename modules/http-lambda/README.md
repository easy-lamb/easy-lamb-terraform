<!-- BEGIN_TF_DOCS -->
# Module Terraform HTTP Lambda Easy-Lamb

Allow use to easily deploy HTTP lambda with Terraform.

## Features

- Deploy AWS Lambda
- Associate API Gateway Endpoint to Lambda

## Usage

### With API Gateway module

```hcl
module "easy-lamb-http-lambda" {
  source = "URL"
  version = "LAST_RELEASE_VERSION"
  project_name = "easy-lamb-api"
  environment  = "prod"
  api_gateway = {}
  function = {}
}

module "easy-lamb-api-gateway" {
  source = "URL"
  version = "LAST_RELEASE_VERSION"
  project_name = "easy-lamb-api"
  environment  = "prod"
  api_gateway = {}
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
| [aws_apigatewayv2_integration.lambda_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_lambda_permission.api_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_gateway"></a> [api\_gateway](#input\_api\_gateway) | api\_gateway = {<br/>            authorizers = "The authorizers name bind to their ids"<br/>            id = "The id of the api gateway"<br/>            execution\_arn = "The execution arn of the api gateway"<br/>        } | <pre>object({<br/>    authorizers   = optional(map(object({ id = string, authorization_type = string })), {})<br/>    id            = string<br/>    execution_arn = string<br/>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_function"></a> [function](#input\_function) | function = {<br/>    name = "the name of the function"<br/>    description = "The description of the function"<br/>    memory = "The amount of memory to allocate to the function (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"<br/>    timeout = "The amount of time the function has to run (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)<br/>    source = "The path to the source code for the function (ex: dist/hello)"<br/>    handler = "The name of the handler function in the source code (ex: fileName.functionName)"<br/>    runtime = "The runtime to use for the function (https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime)"<br/>    log\_retention = "The number of days to retain logs for"<br/>    environment = "The environment variables to set for the function"<br/>    policies = "The policies to attach to the function"<br/>    assume\_roles = "The roles to assume for the function"<br/>    http\_path = "The HTTP path to bind to the function (ex: /hello)"<br/>    http\_method = "The HTTP method to bind to the function (ex: GET)"<br/>    authorizer = "The name of the authorizer"<br/>    override\_env = "Read .env file and add values to environment"<br/>  } | <pre>object({<br/>    name          = string<br/>    memory        = number<br/>    timeout       = number<br/>    source        = string<br/>    handler       = string<br/>    runtime       = string<br/>    tracing       = optional(bool, true)<br/>    description   = optional(string)<br/>    log_retention = optional(number, 3)<br/>    environment   = optional(map(string), {})<br/>    policies      = optional(map(string), {})<br/>    assume_roles  = optional(list(string), [])<br/>    http_path     = string<br/>    http_method   = string<br/>    authorizer    = optional(string)<br/>    override_env  = optional(bool, false)<br/>  })</pre> | n/a | yes |
| <a name="input_output_zip_dir"></a> [output\_zip\_dir](#input\_output\_zip\_dir) | The directory to output the zip files to | `string` | `"dist"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project | `string` | n/a | yes |
<!-- END_TF_DOCS -->