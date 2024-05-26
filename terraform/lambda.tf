resource "aws_lambda_function" "btaAPIOperate" {
  filename      = "${path.module}/../lambdas/btaAPIOperate.zip"
  function_name = "btaAPIOperate"
  role          = aws_iam_role.btaAPIOperate.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  depends_on    = [aws_iam_role_policy_attachment.btaAPIOperate]

  environment {
    variables = {
      INSTANCE_ID = aws_instance.bta.id
    }
  }
}

resource "aws_lambda_permission" "btaAPIOperate" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.btaAPIOperate.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.bta.execution_arn}/*/*/*"
}

resource "aws_lambda_layer_version" "pyotp" {
  layer_name          = "pyotp"
  filename            = "${path.module}/../lambdas/pyotp.zip"
  compatible_runtimes = ["python3.12"]
}

resource "aws_lambda_function" "btaAPIAuthAdmin" {
  filename      = "${path.module}/../lambdas/btaAPIAuthAdmin.zip"
  function_name = "btaAPIAuthAdmin"
  role          = aws_iam_role.btaAPIAuthAdmin.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  depends_on    = [aws_iam_role_policy_attachment.btaAPIAuthAdmin]

  layers = [aws_lambda_layer_version.pyotp.arn]

  environment {
    variables = {
      SECRET_ID = aws_secretsmanager_secret.btaAPIAuthTOTPKey.id
    }
  }
}

resource "aws_lambda_permission" "btaAPIAuthAdmin" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.btaAPIAuthAdmin.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.bta.execution_arn}/*/*/*"
}
