output "function_name" {
  value       = aws_lambda_function.lambda.function_name
  description = "The name of the lambda functions"
}

output "function_arn" {
  value       = aws_lambda_function.lambda.arn
  description = "The ARN of the lambda functions"
}

output "function_invoke_arn" {
  value       = aws_lambda_function.lambda.invoke_arn
  description = "The invoke ARN of the lambda functions"
}

output "file_size" {
  description = "The size of the lambda zip file"
  value = format("%.2f %s",
    data.archive_file.lambda_zip.output_size >= 1099511627776 ?
    data.archive_file.lambda_zip.output_size / 1099511627776.0 :
    data.archive_file.lambda_zip.output_size >= 1073741824 ?
    data.archive_file.lambda_zip.output_size / 1073741824.0 :
    data.archive_file.lambda_zip.output_size >= 1048576 ?
    data.archive_file.lambda_zip.output_size / 1048576.0 :
    data.archive_file.lambda_zip.output_size >= 1024 ?
    data.archive_file.lambda_zip.output_size / 1024.0 :
    data.archive_file.lambda_zip.output_size,
    data.archive_file.lambda_zip.output_size >= 1099511627776 ? "TB" :
    data.archive_file.lambda_zip.output_size >= 1073741824 ? "GB" :
    data.archive_file.lambda_zip.output_size >= 1048576 ? "MB" :
    data.archive_file.lambda_zip.output_size >= 1024 ? "KB" :
    "Bytes"
  )
}