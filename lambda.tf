data "archive_file" "lambda_zip" {
  for_each    = { for config in var.functions : config.name => config }
  type        = "zip"
  source_dir  = each.value.source
  output_path = "${path.module}/${var.output_zip_dir}/${each.value.name}.zip"
}

data "local_file" "env_file" {
  for_each = { for config in var.functions : config.name => config }
  filename = "${each.value.source}/.env"
}

resource "aws_lambda_function" "lambda" {
  for_each      = { for config in var.functions : config.name => config }
  filename      = data.archive_file.lambda_zip[each.key].output_path
  function_name = "${local.resources_name}-${each.value.name}"
  description   = each.value.description
  role          = aws_iam_role.lambda_exec.arn
  handler       = each.value.handler
  memory_size   = each.value.memory
  timeout       = each.value.timeout
  tracing_config {
    mode = each.value.tracing ? "Active" : "PassThrough"
  }
  layers           = each.value.tracing ? ["arn:aws:lambda:eu-west-1:580247275435:layer:LambdaInsightsExtension:53"] : [] # TODO - make this region agnostic
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip[each.key].output_path)
  runtime          = each.value.runtime
  environment {
    variables = merge({
      for line in split("\n", data.local_file.env_file[each.key].content) :
      split("=", line)[0] => split("=", line)[1] if length(line) > 0 && !startswith(line, "#")
      },
      {
        for sqs in(each.value.sqs_listeners != null ? each.value.sqs_listeners : []) :
        upper(replace("SQS_QUEUE_URL_${sqs}", "-", "_")) =>
        aws_sqs_queue.sqs[sqs].id if contains((each.value.sqs_listeners != null ? each.value.sqs_listeners : []), sqs)
    })
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  for_each          = { for config in var.functions : config.name => config }
  name              = "/aws/lambda/${local.resources_name}-${each.value.name}"
  retention_in_days = each.value.log_retention
}

resource "aws_iam_role_policy_attachment" "lambda_xray_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_insights_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.resources_name}-lambda-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "iot.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "sqs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "cognito_policy" {
  name = "lambda_cognito_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cognito-identity:*",
          "cognito-idp:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "invoke_policy" {
  name = "lambda_invoke_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "lambda_functions" {
  value = { for key, value in var.functions : value.name => aws_lambda_function.lambda[value.name].function_name }
}

output "file_sizes_human_readable" {
  value = {
    for key, value in var.functions : value.name => format("%.2f %s",
      data.archive_file.lambda_zip[value.name].output_size >= 1099511627776 ?
      data.archive_file.lambda_zip[value.name].output_size / 1099511627776.0 :
      data.archive_file.lambda_zip[value.name].output_size >= 1073741824 ?
      data.archive_file.lambda_zip[value.name].output_size / 1073741824.0 :
      data.archive_file.lambda_zip[value.name].output_size >= 1048576 ?
      data.archive_file.lambda_zip[value.name].output_size / 1048576.0 :
      data.archive_file.lambda_zip[value.name].output_size >= 1024 ?
      data.archive_file.lambda_zip[value.name].output_size / 1024.0 :
      data.archive_file.lambda_zip[value.name].output_size,
      data.archive_file.lambda_zip[value.name].output_size >= 1099511627776 ? "TB" :
      data.archive_file.lambda_zip[value.name].output_size >= 1073741824 ? "GB" :
      data.archive_file.lambda_zip[value.name].output_size >= 1048576 ? "MB" :
      data.archive_file.lambda_zip[value.name].output_size >= 1024 ? "KB" :
      "Bytes"
    )
  }
}
