<!-- BEGIN_TF_DOCS -->
# Module Terraform Lambda Easy-Lamb

Allow use to easily deploy lambda with Terraform.

## Features

- Deploy AWS Lambda

## Usage

```hcl
module "easy-lamb-lambda" {
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
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.0 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.custom_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.invoke_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.lambda_insights_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_xray_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [local_file.env_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_function"></a> [function](#input\_function) | function = {<br/>    name = "the name of the function"<br/>    description = "The description of the function"<br/>    memory = "The amount of memory to allocate to the function (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"<br/>    timeout = "The amount of time the function has to run (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)<br/>    source = "The path to the source code for the function (ex: dist/hello)"<br/>    handler = "The name of the handler function in the source code (ex: fileName.functionName)"<br/>    runtime = "The runtime to use for the function (https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime)"<br/>    log\_retention = "The number of days to retain logs for"<br/>    environment = "The environment variables to set for the function"<br/>    policies = "The policies to attach to the function"<br/>    assume\_roles = "The roles to assume for the function"<br/>    override\_env = "Read .env file and add values to environment"<br/>  } | <pre>object({<br/>    name          = string<br/>    memory        = number<br/>    timeout       = number<br/>    source        = string<br/>    handler       = string<br/>    runtime       = string<br/>    tracing       = optional(bool, true)<br/>    description   = optional(string)<br/>    log_retention = optional(number, 3)<br/>    environment   = optional(map(string), {})<br/>    policies      = optional(map(string), {})<br/>    assume_roles  = optional(list(string), [])<br/>    override_env  = optional(bool, false)<br/>  })</pre> | n/a | yes |
| <a name="input_output_zip_dir"></a> [output\_zip\_dir](#input\_output\_zip\_dir) | The directory to output the zip files to | `string` | `"dist"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the project | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_file_size"></a> [file\_size](#output\_file\_size) | The size of the lambda zip file |
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | The ARN of the lambda functions |
| <a name="output_function_invoke_arn"></a> [function\_invoke\_arn](#output\_function\_invoke\_arn) | The invoke ARN of the lambda functions |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | The name of the lambda functions |
<!-- END_TF_DOCS -->