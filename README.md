<!-- BEGIN_TF_DOCS -->
# Module Terraform Easy-Lamb

Allow use to easily deploy AWS Lambda functions with Terraform.

## Features

- Deploy AWS API Gateway
- Associate Authorizer to API Gateway
- Deploy AWS Lambda function
- Bind AWS Lambda function to API Gateway
- Bind AWS Lambda function to SQS queue
- Bind AWS Lambda function to IoT rule
- Bind AWS Lambda function to Cron event

## Usage

### As module

```hcl
module "easy-lamb" {
  source = "URL"
  version = "LAST_RELEASE_VERSION"
  project_name = "easy-lamb-api"
  aws_region   = "eu-west-1"
  environment  = "prod"

  functions = [
    {
      name        = "get-user-data"
      memory      = 128
      timeout     = 30
      source      = "dist/get-user-data"
      handler     = "get-user-data.handler"
      runtime     = "nodejs18.x"
      http        = true
      http_method  = "GET"
      http_path    = "/users/{userId}"
      description = "Retrieve user data by user ID"
    }
  ]
}
```

### As standalone

- Clone the repository
- Edit the file providers.tf
- Create a file variables.tf based on the example below

## Examples

Vous trouverez un exemple d'utilisation du module dans le répertoire [examples](./examples/azurerm/cdn-storage).

# Generated documentation

This documentation is generated using terraform-docs. Please do not edit it manually.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ./modules/api_gateway | n/a |
| <a name="module_cron"></a> [cron](#module\_cron) | ./modules/cron-lambda | n/a |
| <a name="module_http"></a> [http](#module\_http) | ./modules/http-lambda | n/a |
| <a name="module_iot"></a> [iot](#module\_iot) | ./modules/iot-lambda | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ./modules/lambda | n/a |
| <a name="module_sqs"></a> [sqs](#module\_sqs) | ./modules/sqs-lambda | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_gateway"></a> [api\_gateway](#input\_api\_gateway) | api\_gateway = {<br/>        cors = {<br/>          allow\_origins = "The origins to allow"<br/>          allow\_methods = "The methods to allow"<br/>          allow\_headers = "The headers to allow"<br/>        }<br/>        authorizer = {<br/>          name = "The name of the authorizer"<br/>          audience = "The audience for the authorizer"<br/>          issuer = "The issuer for the authorizer"<br/>          identity\_sources = "The identity sources for the authorizer"<br/>        }<br/>        log\_retention = "The number of days to retain logs for"<br/>    } | <pre>object({<br/>    cors = optional(object({<br/>      allow_origins = optional(list(string), ["*"])<br/>      allow_methods = optional(list(string), ["GET", "POST", "PUT", "DELETE", "OPTIONS"])<br/>      allow_headers = optional(list(string), ["WebHook-Allowed-Origin", "Authorization", "Content-Type"])<br/>      }), {<br/>      allow_origins = ["*"]<br/>      allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]<br/>      allow_headers = ["WebHook-Allowed-Origin", "Authorization", "Content-Type"]<br/>    })<br/>    authorizer = optional(list(object({<br/>      name             = string<br/>      audience         = list(string)<br/>      issuer           = string<br/>      identity_sources = list(string)<br/>    })), [])<br/>    log_retention = optional(number, 14)<br/>  })</pre> | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to deploy to | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_functions"></a> [functions](#input\_functions) | functions = {<br/>    name = "the name of the function"<br/>    description = "The description of the function"<br/>    memory = "The amount of memory to allocate to the function (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"<br/>    timeout = "The amount of time the function has to run (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)<br/>    source = "The path to the source code for the function (ex: dist/hello)"<br/>    handler = "The name of the handler function in the source code (ex: fileName.functionName)"<br/>    runtime = "The runtime to use for the function (https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime)"<br/>    http = "Whether the function is an HTTP function, if true bind to an HTTP API Gateway with values from httpMethod, httpPath and authorizer"<br/>    http\_method = "The HTTP method to bind to the function (ex: GET)"<br/>    http\_path = "The HTTP path to bind to the function (ex: /hello)"<br/>    authorizer = "The name of the authorizer to use for the function"<br/>    mqtt = "Whether the function is an MQTT function, if true bind to an MQTT topic with values from mqttSql"<br/>    mqtt\_sql = "The MQTT SQL to bind to the function (ex: SELECT * FROM 'topic')"<br/>    sqs = "Whether the function is an SQS function, if true bind to an SQS queue<br/>    sqs\_listeners = "The names of the SQS queues to bind to the function (ex: ['mysuper-function-name'])"<br/>    cron = "The cron expression to trigger the function (ex: 0 23 * * ? *)"<br/>    log\_retention = "The number of days to retain logs for"<br/>    environment = "The environment variables to set for the function"<br/>    assume\_roles = "The roles to assume for the function"<br/>    policies = "The policies to attach to the function"<br/>  } | <pre>list(object({<br/>    name          = string<br/>    memory        = number<br/>    timeout       = number<br/>    source        = string<br/>    handler       = string<br/>    runtime       = string<br/>    tracing       = optional(bool, true)<br/>    http          = optional(bool, false)<br/>    http_method   = optional(string)<br/>    http_path     = optional(string)<br/>    authorizer    = optional(string)<br/>    mqtt          = optional(bool, false)<br/>    mqttSql       = optional(string)<br/>    sqs           = optional(bool, false)<br/>    cron          = optional(string)<br/>    description   = optional(string)<br/>    environment   = optional(map(string), {})<br/>    sqs_listeners = optional(list(string), [])<br/>    log_retention = optional(number, 3)<br/>    assume_roles  = optional(list(string), [])<br/>    policies      = optional(map(string), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_output_zip_dir"></a> [output\_zip\_dir](#input\_output\_zip\_dir) | The directory to output the zip files to | `string` | `"dist"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project | `string` | n/a | yes |
<!-- END_TF_DOCS -->