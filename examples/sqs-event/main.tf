module "easy-lamb" {
  source = "../../"

  project_name = "easy-lamb-api"
  aws_region   = "eu-west-1"
  environment  = "prod"

  api_gateway = {}

  functions = [
    {
      name        = "process-payment"
      memory      = 128
      timeout     = 60
      source      = "examples/sqs-event/sources/process"
      handler     = "process-payment.handler"
      runtime     = "python3.10"
      sqs         = true
      description = "Process payment messages from the SQS queue"
    },
    {
      name         = "send-email"
      memory       = 128
      timeout      = 60
      source       = "examples/sqs-event/sources/send"
      handler      = "send-email.handler"
      runtime      = "python3.10"
      http         = true
      http_method  = "POST"
      http_path    = "/send-email"
      description  = "Send email messages from the SQS queue"
      sqs_listener = ["process-payment"]
      # Inject the SQS queue URL to the environment variable `SQS_QUEUE_URL_process-payment`
    }
  ]
}