#-------------------------------------------------------------------
#Step 1 Create an API + integration(can be multiple integrations) with lambda
#-------------------------------------------------------------------
resource "aws_apigatewayv2_api" "apigatewayv2-api" {
  name                       = "${local.default_name}-http-api"
  description                = "http api2 project"
  protocol_type              = "HTTP"
  api_key_selection_expression = "$request.header.x-api-key"
  route_selection_expression   = "$request.method $request.path"
  
  tags  = {
    Name = "${local.default_name}-api-rest"
  }
}

#-------------------------------------------------------------------------------------------------------------------
resource "aws_apigatewayv2_integration" "apigatewayv2-integration" {
  api_id                    = aws_apigatewayv2_api.apigatewayv2-api.id
  integration_type          = "AWS_PROXY"

  connection_type           = "INTERNET"
 
  description               = "Lambda integration with api http"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.lambda-function.invoke_arn

  passthrough_behavior      = "WHEN_NO_MATCH"
  timeout_milliseconds      = 29000
}
#-------------------------------------------------------------------------------------------------------------------
#There are two types of Lambda authorizers:

# A token-based Lambda authorizer (also called a TOKEN authorizer) receives the caller's identity in a bearer token, such as a JSON Web Token (JWT) or an OAuth token.

# A request parameter-based Lambda authorizer (also called a REQUEST authorizer) receives the caller's identity in a combination of headers, query string parameters, stageVariables, and $context variables.

# For WebSocket APIs, only request parameter-based authorizers are supported.
#-------------------------------------------------------------------
# resource "aws_apigatewayv2_authorizer" "apigatewayv2-authorizer" {
#   name             = "${local.default_name}-auth"
#   api_id           = aws_apigatewayv2_api.apigatewayv2-api.id
#   authorizer_type  = "REQUEST"
#   #authorizer_uri   = aws_lambda_function.lambda-function-auth.invoke_arn
#   #authorizer_uri   = aws_lambda_function.lambda-function-auth.invoke_arn
#   identity_sources = ["route.request.header.Auth"]

#   #identity_sources = ["method.request.header.Authorization"]
  
# }
#-------------------------------------------------------------------
#[for i in toset([ 1,2,3 ]) : format("$%s",i)]
resource "aws_apigatewayv2_route" "apigatewayv2-route" {
  api_id              = aws_apigatewayv2_api.apigatewayv2-api.id
  route_key           = "GET /hello"

  authorization_type  = "NONE"
  #authorizer_id       = aws_apigatewayv2_authorizer.apigatewayv2-authorizer.id
  target              = "integrations/${aws_apigatewayv2_integration.apigatewayv2-integration.id}"
}
#-------------------------------------------------------------------
# resource "aws_apigatewayv2_route" "apigatewayv2-route-auth" {
#   api_id              = aws_apigatewayv2_api.apigatewayv2-api.id
#   route_key           = "$default"

#   authorization_type  = "CUSTOM"
#   authorizer_id       = aws_apigatewayv2_authorizer.apigatewayv2-authorizer.id
#   target              = aws_lambda_function.lambda-function-auth.function_name
# }
#-------------------------------------------------------------------
resource "aws_apigatewayv2_stage" "apigatewayv2_stage" {
  name   = "prod"
  description = "stage for production"
  
  api_id = aws_apigatewayv2_api.apigatewayv2-api.id
  auto_deploy  = true
  stage_variables = {}

  tags = {
    Name =  "${local.default_name}-prod-stage"
  }
}
#-------------------------------------------------------------------
resource "aws_apigatewayv2_deployment" "apigatewayv2-deployment" {
  api_id      = aws_apigatewayv2_route.apigatewayv2-route.api_id
  description = "apigatewayv2 deployment"

  lifecycle {
    create_before_destroy = true
  }
}
#-------------------------------------------------------------------
output "api-endpoint" {
  description = "The URI of the API"
  value       = aws_apigatewayv2_api.apigatewayv2-api.api_endpoint 
}
#-------------------------------------------------------------------