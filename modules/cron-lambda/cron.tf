resource "aws_cloudwatch_event_rule" "event" {
  name                = "${local.resources_name}-${var.function.name}-rule"
  schedule_expression = "cron(${var.function.cron})"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.event.name
  target_id = "${local.resources_name}-${var.function.name}-target"
  arn       = module.lambda.function_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event.arn
}