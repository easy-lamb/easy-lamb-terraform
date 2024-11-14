locals {
  tags = {
    project     = var.project_name
    environment = var.environment
    provider    = "easy-lamb-terraform"
  }

  lambda_functions = { for func in var.functions : func.name => func if func.http == false && func.mqtt == false && func.sqs == false && func.cron == null }
  http_functions   = { for func in var.functions : func.name => func if func.http == true }
  mqtt_functions   = { for func in var.functions : func.name => func if func.mqtt == true }
  sqs_functions    = { for func in var.functions : func.name => func if func.sqs == true }
  cron_functions   = { for func in var.functions : func.name => func if func.cron != null }
}

module "api_gateway" {
  count = length(local.http_functions) > 0 ? 1 : 0

  source = "./modules/api_gateway"

  project_name = var.project_name
  environment  = var.environment
  api_gateway  = var.api_gateway
}

module "lambda" {
  for_each = local.lambda_functions

  source = "./modules/lambda"

  project_name   = var.project_name
  environment    = var.environment
  output_zip_dir = var.output_zip_dir
  function = {
    name          = each.value.name
    description   = each.value.description
    memory        = each.value.memory
    timeout       = each.value.timeout
    source        = each.value.source
    handler       = each.value.handler
    runtime       = each.value.runtime
    tracing       = each.value.tracing
    log_retention = each.value.log_retention
    environment = merge(each.value.environment, {
      for listener in each.value.sqs_listeners : "SQS_QUEUE_URL_${listener}" => module.sqs[listener]
    })
    policies     = each.value.policies
    assume_roles = each.value.assume_roles
  }
}

module "cron" {
  for_each = local.cron_functions

  source = "./modules/cron-lambda"

  project_name   = var.project_name
  environment    = var.environment
  output_zip_dir = var.output_zip_dir
  function = {
    name          = each.value.name
    description   = each.value.description
    memory        = each.value.memory
    timeout       = each.value.timeout
    source        = each.value.source
    handler       = each.value.handler
    runtime       = each.value.runtime
    tracing       = each.value.tracing
    log_retention = each.value.log_retention
    environment = merge(each.value.environment, {
      for listener in each.value.sqs_listeners : "SQS_QUEUE_URL_${listener}" => module.sqs[listener]
    })
    policies     = each.value.policies
    assume_roles = each.value.assume_roles
    cron         = each.value.cron
  }
}

module "http" {
  for_each = local.http_functions

  source = "./modules/http-lambda"

  api_gateway = {
    id            = module.api_gateway[0].id
    authorizer    = module.api_gateway[0].authorizers
    execution_arn = module.api_gateway[0].execution_arn
  }

  project_name = var.project_name
  environment  = var.environment
  function = {
    name          = each.value.name
    description   = each.value.description
    memory        = each.value.memory
    timeout       = each.value.timeout
    source        = each.value.source
    handler       = each.value.handler
    runtime       = each.value.runtime
    tracing       = each.value.tracing
    log_retention = each.value.log_retention
    environment = merge(each.value.environment, {
      for listener in each.value.sqs_listeners : "SQS_QUEUE_URL_${listener}" => module.sqs[listener]
    })
    policies        = each.value.policies
    assume_roles    = each.value.assume_roles
    http_path       = each.value.http_path
    http_method     = each.value.http_method
    authorizer_name = each.value.authorizer
  }
}

module "iot" {
  for_each = local.mqtt_functions

  source = "./modules/iot-lambda"

  project_name   = var.project_name
  environment    = var.environment
  output_zip_dir = var.output_zip_dir
  function = {
    name          = each.value.name
    description   = each.value.description
    memory        = each.value.memory
    timeout       = each.value.timeout
    source        = each.value.source
    handler       = each.value.handler
    runtime       = each.value.runtime
    tracing       = each.value.tracing
    log_retention = each.value.log_retention
    environment = merge(each.value.environment, {
      for listener in each.value.sqs_listeners : "SQS_QUEUE_URL_${listener}" => module.sqs[listener]
    })
    policies     = each.value.policies
    assume_roles = each.value.assume_roles
    mqtt         = each.value.mqtt
    mqtt_sql     = each.value.mqtt_sql
  }
}

module "sqs" {
  for_each = local.sqs_functions

  source = "./modules/sqs-lambda"

  project_name   = var.project_name
  environment    = var.environment
  output_zip_dir = var.output_zip_dir
  function = {
    name          = each.value.name
    description   = each.value.description
    memory        = each.value.memory
    timeout       = each.value.timeout
    source        = each.value.source
    handler       = each.value.handler
    runtime       = each.value.runtime
    tracing       = each.value.tracing
    log_retention = each.value.log_retention
    environment   = each.value.environment
    policies      = each.value.policies
    assume_roles  = each.value.assume_roles
  }
}