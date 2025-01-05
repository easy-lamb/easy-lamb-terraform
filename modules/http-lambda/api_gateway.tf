resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = var.api_gateway.id
  payload_format_version = "2.0"
  description            = var.function.description
  integration_type       = "AWS_PROXY"
  integration_uri        = module.lambda.function_invoke_arn
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id             = var.api_gateway.id
  route_key          = var.function.http_method != null ? "${var.function.http_method} ${var.function.http_path}" : "$default"
  authorizer_id      = var.function.authorizer != null ? var.api_gateway.authorizers[var.function.authorizer].id : ""
  authorization_type = var.function.authorizer != null ? var.api_gateway.authorizers[var.function.authorizer].authorization_type : null
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "extra_routes" {
  for_each = { for route in var.function.extra_routes : "${route.method} ${route.path}" => route }

  api_id             = var.api_gateway.id
  route_key          = each.value.method != null ? "${each.value.method} ${each.value.path}" : "$default"
  authorizer_id      = each.value.authorizer != null ? var.api_gateway.authorizers[each.value.authorizer].id : ""
  authorization_type = each.value.authorizer != null ? var.api_gateway.authorizers[each.value.authorizer].authorization_type : null
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_gateway.execution_arn}/*/*"
}
