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
      authorizer_uri   = optional(string)
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
