output "id" {
  value       = aws_apigatewayv2_api.apg.id
  description = "The id of the api gateway"
}

output "execution_arn" {
  value       = aws_apigatewayv2_api.apg.execution_arn
  description = "The execution arn of the api gateway"
}

output "authorizers" {
  value       = { for authorizer in aws_apigatewayv2_authorizer.apga : authorizer.name => authorizer.id }
  description = "The authorizers name bind to their ids"
}