resource "aws_iam_role" "lambda_exec" {
  name = "${local.resources_name}-${var.function.name}-lambda-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for service in local.assume_roles : {
        "Effect" = "Allow",
        "Principal" = {
          "Service" = service
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "invoke_policy" {
  name = "${local.resources_name}-lambda-invoke-policy"
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

resource "aws_iam_role_policy_attachment" "lambda_xray_policy" {
  count      = var.function.tracing ? 1 : 0
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_insights_policy" {
  count      = var.function.tracing ? 1 : 0
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"
}

resource "aws_iam_role_policy" "custom_policies" {
  for_each = var.function.policies
  name     = "${each.key}-lambda-policy"
  role     = aws_iam_role.lambda_exec.id
  policy   = each.value
}