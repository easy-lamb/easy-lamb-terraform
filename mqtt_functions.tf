resource "aws_iam_role_policy" "lambda_exec_iot_policy" {
  name = "lambda_exec_iot_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iot:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iot_topic_rule" "iot_rule" {
  for_each    = local.mqtt_functions
  name        = replace("${local.resources_name}-${each.value.name}-rule", "-", "_")
  sql         = each.value.mqtt_sql
  sql_version = "2015-10-08"
  enabled     = true

  lambda {
    function_arn = aws_lambda_function.lambda[each.key].arn
  }
}

resource "aws_lambda_permission" "allow_iot_invoke" {
  for_each      = local.mqtt_functions
  statement_id  = "AllowExecutionFromIoT"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda[each.key].function_name
  principal     = "iot.amazonaws.com"
  source_arn    = aws_iot_topic_rule.iot_rule[each.key].arn
}

output "mqtt_listener_rules" {
  value = {
    for key, value in local.mqtt_functions : key => "${aws_iot_topic_rule.iot_rule[key].name} (${value.mqtt_sql})"
  }
}
