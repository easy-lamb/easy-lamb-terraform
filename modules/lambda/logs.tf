resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${local.resources_name}-${var.function.name}"
  retention_in_days = var.function.log_retention
}