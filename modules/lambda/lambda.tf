resource "aws_lambda_function" "lambda" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "${local.resources_name}-${var.function.name}"
  description   = var.function.description
  role          = aws_iam_role.lambda_exec.arn
  handler       = var.function.handler
  memory_size   = var.function.memory
  timeout       = var.function.timeout
  architectures = var.function.architectures
  tracing_config {
    mode = var.function.tracing ? "Active" : "PassThrough"
  }
  layers           = local.layers
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
  runtime          = var.function.runtime
  environment {
    variables = merge(var.function.override_env ? {
      for line in split("\n", data.local_file.env_file.content) :
      split("=", line)[0] => split("=", line)[1] if length(line) > 0 && !startswith(line, "#")
      } : {},
    var.function.environment)
  }
}
