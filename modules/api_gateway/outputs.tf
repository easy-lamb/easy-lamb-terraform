output "id" {
  value       = aws_apigatewayv2_api.apg.id
  description = "The id of the api gateway"
}

output "execution_arn" {
  value       = aws_apigatewayv2_api.apg.execution_arn
  description = "The execution arn of the api gateway"
}

output "authorizers" {
  value = {
    for authorizer in aws_apigatewayv2_authorizer.apga : authorizer.name =>
    { id : authorizer.id, authorization_type : authorizer.authorizer_type == "JWT" ? "JWT" : "CUSTOM" }
  }
  description = "The authorizers name bind to their ids"
}
