resource "aws_cloudwatch_event_rule" "event" {
  for_each            = local.cron_functions
  name                = "${local.resources_name}-${each.key}-rule"
  schedule_expression = "cron(${each.value.cron})"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  for_each  = local.cron_functions
  rule      = aws_cloudwatch_event_rule.event[each.key].name
  target_id = "${local.resources_name}-${each.key}-target"
  arn       = aws_lambda_function.lambda[each.key].arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  for_each      = local.cron_functions
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[each.key].function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.event[each.key].arn
}
