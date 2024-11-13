resource "aws_sqs_queue" "sqs" {
  for_each = local.sqs_functions
  name     = "${local.resources_name}-${each.value.name}-sqs"
}

resource "aws_iam_role_policy" "lambda_sqs_policy" {
  name = "lambda_exec_sqs_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:*",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  for_each         = local.sqs_functions
  event_source_arn = aws_sqs_queue.sqs[each.key].arn
  function_name    = aws_lambda_function.lambda[each.key].arn
  batch_size       = 3
}

output "sqs_listener_url" {
  value = { for key, value in local.sqs_functions : key => aws_sqs_queue.sqs[key].url }
}
