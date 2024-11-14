<!-- BEGIN_TF_DOCS -->
# Module Terraform API Gateway Easy-Lamb

Allow use to easily deploy AWS API Gateway for lambda with Terraform.

## Features

- Deploy AWS API Gateway
- Associate Authorizer to API Gateway

## Usage

```hcl
module "easy-lamb" {
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

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.apg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_authorizer.apga](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer) | resource |
| [aws_apigatewayv2_stage.default_stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_cloudwatch_log_group.api_gw_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_gateway"></a> [api\_gateway](#input\_api\_gateway) | api\_gateway = {<br/>        cors = {<br/>          allow\_origins = "The origins to allow"<br/>          allow\_methods = "The methods to allow"<br/>          allow\_headers = "The headers to allow"<br/>        }<br/>        authorizer = {<br/>          name = "The name of the authorizer"<br/>          audience = "The audience for the authorizer"<br/>          issuer = "The issuer for the authorizer"<br/>          identity\_sources = "The identity sources for the authorizer"<br/>        }<br/>        log\_retention = "The number of days to retain logs for"<br/>    } | <pre>object({<br/>    cors = optional(object({<br/>      allow_origins = optional(list(string), ["*"])<br/>      allow_methods = optional(list(string), ["GET", "POST", "PUT", "DELETE", "OPTIONS"])<br/>      allow_headers = optional(list(string), ["WebHook-Allowed-Origin", "Authorization", "Content-Type"])<br/>      }), {<br/>      allow_origins = ["*"]<br/>      allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]<br/>      allow_headers = ["WebHook-Allowed-Origin", "Authorization", "Content-Type"]<br/>    })<br/>    authorizer = optional(list(object({<br/>      name             = string<br/>      audience         = list(string)<br/>      issuer           = string<br/>      identity_sources = list(string)<br/>    })), [])<br/>    log_retention = optional(number, 14)<br/>  })</pre> | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_authorizers"></a> [authorizers](#output\_authorizers) | The authorizers name bind to their ids |
| <a name="output_execution_arn"></a> [execution\_arn](#output\_execution\_arn) | The execution arn of the api gateway |
| <a name="output_id"></a> [id](#output\_id) | The id of the api gateway |
<!-- END_TF_DOCS -->