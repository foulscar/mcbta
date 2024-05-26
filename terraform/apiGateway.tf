resource "aws_apigatewayv2_api" "bta" {
  name          = "bta-http-api"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["http://localhost", "https://bta.corbinpersonal.me"]
    allow_methods = ["OPTIONS", "POST"]
    allow_headers = ["*"]
    max_age       = 3000
  }
}

resource "aws_apigatewayv2_domain_name" "bta" {
  domain_name = "api.bta.corbinpersonal.me"
  domain_name_configuration {
    certificate_arn = aws_acm_certificate.bta_api.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_stage" "bta_main" {
  api_id      = aws_apigatewayv2_api.bta.id
  name        = "main"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.bta_api_log_group.arn
    format = jsonencode({
      requestId       = "$context.requestId",
      ip              = "$context.identity.sourceIp",
      caller          = "$context.identity.caller",
      user            = "$context.identity.user",
      requestTime     = "$context.requestTime",
      httpMethod      = "$context.httpMethod",
      resourcePath    = "$context.resourcePath",
      status          = "$context.status",
      protocol        = "$context.protocol",
      responseLength  = "$context.responseLength",
      authorizerError = "$context.authorizer.error"
      lambdaOutput    = "$context.integration.output"
    })
  }

  default_route_settings {
    detailed_metrics_enabled = true
    logging_level            = "INFO"
    data_trace_enabled       = true
    throttling_burst_limit   = 2
    throttling_rate_limit    = 5
  }
}

resource "aws_apigatewayv2_api_mapping" "bta" {
  api_id      = aws_apigatewayv2_api.bta.id
  domain_name = aws_apigatewayv2_domain_name.bta.domain_name
  stage       = "main"

  depends_on = [aws_apigatewayv2_stage.bta_main]
}

resource "aws_apigatewayv2_authorizer" "btaAdmin" {
  api_id                            = aws_apigatewayv2_api.bta.id
  authorizer_type                   = "REQUEST"
  identity_sources                  = ["$request.header.Authorization"]
  enable_simple_responses           = true
  name                              = "btaAdmin"
  authorizer_uri                    = aws_lambda_function.btaAPIAuthAdmin.invoke_arn
  authorizer_payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "btaOperate" {
  api_id             = aws_apigatewayv2_api.bta.id
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.btaAPIOperate.invoke_arn
}

resource "aws_apigatewayv2_route" "btaOperate" {
  api_id             = aws_apigatewayv2_api.bta.id
  route_key          = "POST /operate"
  target             = "integrations/${aws_apigatewayv2_integration.btaOperate.id}"
  authorization_type = "CUSTOM"
  authorizer_id      = aws_apigatewayv2_authorizer.btaAdmin.id
}
