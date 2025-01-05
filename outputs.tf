output "api_gateway" {
  value       = try(module.api_gateway[0].api_gateway, null)
  description = "The api gateway"
}

output "api_gateway_stage" {
  value       = try(module.api_gateway[0].api_gateway_stage, null)
  description = "The api gateway stage"
}