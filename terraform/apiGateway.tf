resource "aws_apigatewayv2_api" "bta" {
  name = "bta-http-api"
  protocol_type = "HTTP"
}

resource "aws_api_gateway_domain_name" "bta" {
  certificate_arn = aws_acm_certificate.bta_api.arn
  domain_name = "api.bta.corbinpersonal.me"
}
