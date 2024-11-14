variable "output_zip_dir" {
  description = "The directory to output the zip files to"
  type        = string
  default     = "dist"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "function" {
  type = object({
    name          = string
    memory        = number
    timeout       = number
    source        = string
    handler       = string
    runtime       = string
    tracing       = optional(bool, true)
    description   = optional(string)
    log_retention = optional(number, 3)
    environment   = optional(map(string), {})
    policies      = optional(map(string), {})
    assume_roles  = optional(list(string), [])
    cron          = string
  })
  description = <<EOT
  function = {
    name = "the name of the function"
    description = "The description of the function"
    memory = "The amount of memory to allocate to the function (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"
    timeout = "The amount of time the function has to run (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)
    source = "The path to the source code for the function (ex: dist/hello)"
    handler = "The name of the handler function in the source code (ex: fileName.functionName)"
    runtime = "The runtime to use for the function (https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime)"
    log_retention = "The number of days to retain logs for"
    environment = "The environment variables to set for the function"
    policies = "The policies to attach to the function"
    assume_roles = "The roles to assume for the function"
    cron = "The cron expression to trigger the lambda function"
  }
    EOT
}
