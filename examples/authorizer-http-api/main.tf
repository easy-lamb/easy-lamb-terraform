module "easy-lamb" {
  source = "../../"

  project_name = "easy-lamb-api"
  aws_region   = "eu-west-1"
  environment  = "prod"

  api_gateway = {
    # Define default authorizer for the API
    authorizer = [
      {
        name             = "default-authorizer"
        identity_sources = ["method.request.header.Authorization"]
        issuer           = "FAKE_ISSUER_URL"
        audience         = ["FAKE_AUDIENCE"]
      }
    ]
  }

  functions = [
    {
      name        = "get-user-data"
      memory      = 128
      timeout     = 30
      source      = "examples/authorizer-http-api/sources"
      handler     = "get-user-data.handler"
      runtime     = "nodejs18.x"
      http        = true
      http_method = "GET"
      http_path   = "/users/{userId}"
      authorizer  = "default-authorizer"
      description = "Retrieve user data by user ID"
    }
  ]
}