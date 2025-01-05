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

variable "api_gateway" {
  type = object({
    authorizers   = optional(map(object({ id = string, authorization_type = string })), {})
    id            = string
    execution_arn = string
  })
  description = <<EOT
        api_gateway = {
            authorizers = "The authorizers name bind to their ids"
            id = "The id of the api gateway"
            execution_arn = "The execution arn of the api gateway"
        }
            EOT
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
    http_path     = string
    http_method   = string
    authorizer    = optional(string)
    override_env  = optional(bool, false)
    layers        = optional(list(string), [])
    extra_routes = optional(list(object({
      path       = string
      method     = string
      authorizer = optional(string)
    })), [])
    architectures = optional(list(string), ["x86_64"])
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
    http_path = "The HTTP path to bind to the function (ex: /hello)"
    http_method = "The HTTP method to bind to the function (ex: GET)"
    authorizer = "The name of the authorizer"
    override_env = "Read .env file and add values to environment"
    layers = "The layers to attach to the function"
    extra_routes = "Extra routes to add to the function"
    architectures = "The architectures to build the function for"
  }
    EOT
}
