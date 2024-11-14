module "easy-lamb" {
  source = "../../"

  project_name = "easy-lamb-api"
  aws_region   = "eu-west-1"
  environment  = "prod"

  api_gateway = {}

  functions = [
    {
      name        = "get-user-data"
      memory      = 128
      timeout     = 30
      source      = "examples/http-api/sources"
      handler     = "get-user-data.handler"
      runtime     = "nodejs18.x"
      http        = true
      http_method = "GET"
      http_path   = "/users/{userId}"
      description = "Retrieve user data by user ID"
    }
  ]
}