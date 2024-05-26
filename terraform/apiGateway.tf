resource "aws_apigatewayv2_api" "bta" {
  name          = "bta-http-api"
  protocol_type = "HTTP"
}

resource "aws_api_gateway_domain_name" "bta" {
  certificate_arn = aws_acm_certificate.bta_api.arn
  domain_name     = "api.bta.corbinpersonal.me"
}

resource "aws_apigatewayv2_stage" "bta_main" {
  api_id = aws_apigatewayv2_api.bta.id
  name = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_authorizer" "btaAdmin" {
  api_id = aws_apigatewayv2_api.bta.id
  authorizer_type = "REQUEST"
  name = "btaAdmin"
  authorizer_uri = aws_lambda_function.btaAPIAuthAdmin.invoke_arn
  authorizer_payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "btaOperate" {
  api_id = aws_apigatewayv2_api.bta.id
  integration_type = "AWS_PROXY"
  integration_method = "POST"
  integration_uri = aws_lambda_function.btaAPIOperate.invoke_arn
}

resource "aws_apigatewayv2_route" "btaOperate" {
  api_id = aws_apigatewayv2_api.bta.id
  route_key = "POST /operate"
  target = "integrations/${aws_lambda_function.btaAPIAuthAdmin.id}"
  authorizer_id = aws_apigatewayv2_authorizer.btaAdmin.id

  depends_on = [ aws_apigatewayv2_integration.btaOperate ]
}
