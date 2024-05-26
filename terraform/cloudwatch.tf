resource "aws_cloudwatch_log_group" "bta_api_log_group" {
  name              = "/aws/apigateway/bta-http-api"
  retention_in_days = 3
}
