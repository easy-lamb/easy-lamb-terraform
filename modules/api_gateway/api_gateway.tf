resource "aws_apigatewayv2_api" "apg" {
  name          = "${local.resources_name}-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = var.api_gateway.cors.allow_origins
    allow_methods = var.api_gateway.cors.allow_methods
    allow_headers = var.api_gateway.cors.allow_headers
  }
}

resource "aws_apigatewayv2_authorizer" "apga" {
  for_each                          = { for authorizer in var.api_gateway.authorizer : authorizer.name => authorizer }
  api_id                            = aws_apigatewayv2_api.apg.id
  authorizer_type                   = each.value.audience != null && each.value.issuer != null ? "JWT" : "REQUEST"
  authorizer_uri                    = each.value.authorizer_uri
  identity_sources                  = each.value.identity_sources
  authorizer_payload_format_version = each.value.authorizer_uri != null ? "2.0" : null
  enable_simple_responses           = each.value.authorizer_uri != null ? true : null
  name                              = each.value.name

  dynamic "jwt_configuration" {
    for_each = each.value.audience != null && each.value.issuer != null ? [each.value] : []
    content {
      audience = each.value.audience
      issuer   = each.value.issuer
    }
  }
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.apg.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_log_group.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      routeKey       = "$context.routeKey"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_cloudwatch_log_group" "api_gw_log_group" {
  name              = "/aws/api-gateway/${aws_apigatewayv2_api.apg.name}"
  retention_in_days = var.api_gateway.log_retention
}
