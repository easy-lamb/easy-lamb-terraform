resource "aws_iot_topic_rule" "iot_rule" {
  name        = replace("${local.resources_name}-${var.function.name}-rule", "-", "_")
  sql         = var.function.mqtt_sql
  sql_version = "2015-10-08"
  enabled     = true

  lambda {
    function_arn = module.lambda.function_arn
  }
}

resource "aws_lambda_permission" "allow_iot_invoke" {
  statement_id  = "AllowExecutionFromIoT"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.iot_rule.arn
}