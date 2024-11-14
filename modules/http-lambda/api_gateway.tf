resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = var.api_gateway.id
  payload_format_version = "2.0"
  description            = var.function.description
  integration_type       = "AWS_PROXY"
  integration_uri        = module.lambda.function_invoke_arn
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id             = var.api_gateway.id
  route_key          = "${var.function.http_method} ${var.function.http_path}"
  authorizer_id      = var.function.authorizer != null ? var.api_gateway.authorizers[var.function.authorizer] : ""
  authorization_type = var.function.authorizer != null ? "JWT" : null
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway.execution_arn}/*/*"
}