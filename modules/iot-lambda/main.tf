locals {
  resources_name = "${lower(var.project_name)}-${lower(var.environment)}"

  policies = merge(var.function.policies,
    {
      "lambda_iot_policy" : jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "iot:*"
            ]
            Resource = "*"
          }
        ]
      })
  })
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "lambda" {
  source = "../lambda"

  project_name = var.project_name
  environment  = var.environment
  function = {
    name          = var.function.name
    memory        = var.function.memory
    timeout       = var.function.timeout
    source        = var.function.source
    handler       = var.function.handler
    runtime       = var.function.runtime
    tracing       = var.function.tracing
    description   = var.function.description
    log_retention = var.function.log_retention
    environment   = var.function.environment
    assume_roles  = var.function.assume_roles
    override_env  = var.function.override_env
    policies      = local.policies
  }
}
