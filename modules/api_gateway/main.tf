locals {
  resources_name = "${lower(var.project_name)}-${lower(var.environment)}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}