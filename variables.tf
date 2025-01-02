variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "output_zip_dir" {
  description = "The directory to output the zip files to"
  type        = string
  default     = "dist"
}

variable "api_gateway" {
  type = object({
    cors = optional(object({
      allow_origins = optional(list(string), ["*"])
      allow_methods = optional(list(string), ["GET", "POST", "PUT", "DELETE", "OPTIONS"])
      allow_headers = optional(list(string), ["WebHook-Allowed-Origin", "Authorization", "Content-Type"])
      }), {
      allow_origins = ["*"]
      allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
      allow_headers = ["WebHook-Allowed-Origin", "Authorization", "Content-Type"]
    })
    authorizer = optional(list(object({
      name             = string
      audience         = optional(list(string))
      issuer           = optional(string)
      authorizer_type  = optional(string, "JWT")
      function_name    = optional(string)
      identity_sources = list(string)
    })), [])
    log_retention = optional(number, 14)
  })
  description = <<EOT
    api_gateway = {
        cors = {
          allow_origins = "The origins to allow"
          allow_methods = "The methods to allow"
          allow_headers = "The headers to allow"
        }
        authorizer = {
          name = "The name of the authorizer"
          audience = "The audience for the authorizer"
          issuer = "The issuer for the authorizer"
          identity_sources = "The identity sources for the authorizer"
        }
        log_retention = "The number of days to retain logs for"
    }
        EOT
}

variable "functions" {
  type = list(object({
    name          = string
    memory        = number
    timeout       = number
    source        = string
    handler       = string
    runtime       = string
    tracing       = optional(bool, true)
    http          = optional(bool, false)
    http_method   = optional(string)
    http_path     = optional(string)
    authorizer    = optional(string)
    mqtt          = optional(bool, false)
    mqtt_sql      = optional(string)
    sqs           = optional(bool, false)
    cron          = optional(string)
    description   = optional(string)
    environment   = optional(map(string), {})
    sqs_listeners = optional(list(string), [])
    log_retention = optional(number, 3)
    assume_roles  = optional(list(string), [])
    policies      = optional(map(string), {})
    override_env  = optional(bool, false)
  }))
  description = <<EOT
  functions = {
    name = "the name of the function"
    description = "The description of the function"
    memory = "The amount of memory to allocate to the function (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)"
    timeout = "The amount of time the function has to run (https://docs.aws.amazon.com/lambda/latest/dg/limits.html)
    source = "The path to the source code for the function (ex: dist/hello)"
    handler = "The name of the handler function in the source code (ex: fileName.functionName)"
    runtime = "The runtime to use for the function (https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime)"
    http = "Whether the function is an HTTP function, if true bind to an HTTP API Gateway with values from httpMethod, httpPath and authorizer"
    http_method = "The HTTP method to bind to the function (ex: GET)"
    http_path = "The HTTP path to bind to the function (ex: /hello)"
    authorizer = "The name of the authorizer to use for the function"
    mqtt = "Whether the function is an MQTT function, if true bind to an MQTT topic with values from mqtt_sql"
    mqtt_sql = "The MQTT SQL to bind to the function (ex: SELECT * FROM 'topic')"
    sqs = "Whether the function is an SQS function, if true bind to an SQS queue
    sqs_listeners = "The names of the SQS queues to bind to the function (ex: ['mysuper-function-name'])"
    cron = "The cron expression to trigger the function (ex: 0 23 * * ? *)"
    log_retention = "The number of days to retain logs for"
    environment = "The environment variables to set for the function"
    assume_roles = "The roles to assume for the function"
    policies = "The policies to attach to the function"
    override_env = "Read .env file and add values to environment"
  }
    EOT
}
