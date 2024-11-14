locals {
  resources_name = "${lower(var.project_name)}-${lower(var.environment)}"
  assume_roles = concat(
    var.function.assume_roles,
    ["lambda.amazonaws.com"]
  )
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}