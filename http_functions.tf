resource "aws_apigatewayv2_integration" "lambda_integration" {
  for_each               = local.http_functions
  api_id                 = aws_apigatewayv2_api.apg.id
  payload_format_version = "2.0"
  description            = aws_lambda_function.lambda[each.key].description
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.lambda[each.key].invoke_arn
}

resource "aws_apigatewayv2_route" "default_route" {
  for_each  = local.http_functions
  api_id    = aws_apigatewayv2_api.apg.id
  route_key = "${each.value.http_method} ${each.value.http_path}"
  # Only if each.value.noAuthorizer is false
  authorizer_id      = each.value.authorizer != null ? aws_apigatewayv2_authorizer.apga[each.value.authorizer].id : ""
  authorization_type = each.value.authorizer != null ? "JWT" : null
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration[each.key].id}"
}


resource "aws_lambda_permission" "api_gateway" {
  for_each      = local.http_functions
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[each.key].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.apg.execution_arn}/*/*"
}

output "http_function_urls" {
  value = {
    for key, value in local.http_functions : key => "(${value.http_method}) https://${aws_apigatewayv2_api.apg.api_endpoint}/${value.http_path}"
  }
}
