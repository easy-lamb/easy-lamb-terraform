resource "aws_sqs_queue" "sqs" {
  name = "${local.resources_name}-${var.function.name}-sqs"
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.sqs.arn
  function_name    = module.lambda.function_arn
  batch_size       = 3
}