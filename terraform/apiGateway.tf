resource "aws_apigatewayv2_api" "bta" {
  name          = "bta-http-api"
  protocol_type = "HTTP"
}
