data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../../${var.function.source}"
  output_path = "${path.module}/${var.output_zip_dir}/${var.function.name}.zip"
}

data "local_file" "env_file" {
  filename = "../../${var.function.source}/.env"
}