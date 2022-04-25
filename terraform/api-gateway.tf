

resource "aws_api_gateway_rest_api" "user_api" {
  name        = "user_api"
  description = "This is exposed api for user"
}
resource "aws_api_gateway_resource" "user_stats_resources" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_rest_api.user_api.root_resource_id
  path_part   = "user"
}

# GET user stats
resource "aws_api_gateway_resource" "get_user_stats_resource" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_resource.user_stats_resources.id
  path_part   = "get_user_stats"
}
resource "aws_api_gateway_method" "get_user_stats_method" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.get_user_stats_resource.id
  http_method   = "GET"
  authorization = "NONE"
  # request_parameters = {
  #   "method.request.path.proxy" = {user_id}
  # }
}

resource "aws_api_gateway_integration" "get_user_stats_integration" {
  rest_api_id             = aws_api_gateway_rest_api.user_api.id
  resource_id             = aws_api_gateway_resource.get_user_stats_resource.id
  http_method             = aws_api_gateway_method.get_user_stats_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.get_user_stats_lambda.invoke_arn
  depends_on = [
    aws_lambda_function.get_user_stats_lambda
  ]
}
resource "aws_api_gateway_integration_response" "get_user_stats_integration_response" {
  rest_api_id      = aws_api_gateway_rest_api.user_api.id
  resource_id      = aws_api_gateway_resource.get_user_stats_resource.id
  http_method      = aws_api_gateway_method.get_user_stats_method.http_method
  status_code      = "200"
  content_handling = "CONVERT_TO_TEXT"
  response_templates = {
       "application/json" = ""
   } 
  depends_on = [
    aws_api_gateway_integration.get_user_stats_integration
  ]
}

# POST user data
resource "aws_api_gateway_resource" "post_user_stats_resource" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  parent_id   = aws_api_gateway_resource.user_stats_resources.id
  path_part   = "post_user_stats"
}



resource "aws_api_gateway_method" "post_user_stats_method" {
  rest_api_id   = aws_api_gateway_rest_api.user_api.id
  resource_id   = aws_api_gateway_resource.post_user_stats_resource.id
  http_method   = "POST"
  authorization = "NONE"
  #   request_parameters = true
}
resource "aws_api_gateway_integration" "post_user_stats_integration" {
  rest_api_id             = aws_api_gateway_rest_api.user_api.id
  resource_id             = aws_api_gateway_resource.post_user_stats_resource.id
  http_method             = aws_api_gateway_method.post_user_stats_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.post_user_stats_lambda.invoke_arn
  depends_on = [
    aws_lambda_function.post_user_stats_lambda
  ]
}

resource "aws_api_gateway_integration_response" "post_user_stats_integration_response" {
  rest_api_id      = aws_api_gateway_rest_api.user_api.id
  resource_id      = aws_api_gateway_resource.post_user_stats_resource.id
  http_method      = aws_api_gateway_method.post_user_stats_method.http_method
  status_code      = "200"
  content_handling = "CONVERT_TO_TEXT"
  response_templates = {
       "application/json" = ""
   } 
  depends_on = [
    aws_api_gateway_integration.post_user_stats_integration
  ]
}

resource "aws_api_gateway_deployment" "user_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.user_api.id
  stage_name  = "stage"
  depends_on  = [aws_api_gateway_method.get_user_stats_method, aws_api_gateway_method.post_user_stats_method, aws_api_gateway_integration.get_user_stats_integration, aws_api_gateway_integration.post_user_stats_integration]
}

