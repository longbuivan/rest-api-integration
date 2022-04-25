data "archive_file" "get_user_stats_lambda_file" {
  type        = "zip"
  source_file = "../functions/get_user_stats_lambda.py"
  output_path = "get_user_stats_lambda_file.zip"
}
data "archive_file" "post_user_stats_lambda_file" {
  type        = "zip"
  source_file = "../functions/post_user_stats_lambda.py"
  output_path = "post_user_stats_lambda_file.zip"
}

# Lambda
resource "aws_lambda_permission" "apigw_get_user_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_user_stats_lambda.function_name
  principal     = "apigateway.amazonaws.com"

}
resource "aws_lambda_permission" "apigw_post_user_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.post_user_stats_lambda.function_name
  principal     = "apigateway.amazonaws.com"

}

resource "aws_lambda_function" "get_user_stats_lambda" {
  filename         = data.archive_file.get_user_stats_lambda_file.output_path
  source_code_hash = data.archive_file.get_user_stats_lambda_file.output_base64sha256
  function_name    = "get_user_stats_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "get_user_stats_lambda.lambda_handler"
  runtime          = "python3.7"
}
resource "aws_lambda_function" "post_user_stats_lambda" {
  filename         = data.archive_file.post_user_stats_lambda_file.output_path
  source_code_hash = data.archive_file.post_user_stats_lambda_file.output_base64sha256
  function_name    = "post_user_stats_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "post_user_stats_lambda.lambda_handler"
  runtime          = "python3.7"
}
