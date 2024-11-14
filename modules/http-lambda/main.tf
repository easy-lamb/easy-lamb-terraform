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

  project_name   = var.project_name
  environment    = var.environment
  output_zip_dir = var.output_zip_dir
  function       = var.function
}