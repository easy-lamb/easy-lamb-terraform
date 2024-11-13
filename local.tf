locals {
  tags = {
    project     = var.project_name
    environment = var.environment
    provider    = "easy-lamb-terraform"
  }

  resources_name = "${lower(var.project_name)}-${lower(var.environment)}"

  # Filter all the var.functions with http = true
  # and create a map with the name of the function as key and all properties as value
  http_functions = { for func in var.functions : func.name => func if func.http == true }
  mqtt_functions = { for func in var.functions : func.name => func if func.mqtt == true }
  sqs_functions  = { for func in var.functions : func.name => func if func.sqs == true }
  cron_functions = { for func in var.functions : func.name => func if func.cron != null }
}
