resource "aws_lambda_function" "btaAPIOperate" {
  filename      = "${path.module}/../lambdas/btaAPIOperate.zip"
  function_name = "btaAPIOperate"
  role          = aws_iam_role.btaAPIOperate.arn
  handler       = "lambda_handler.lambda_handler"
  runtime       = "python3.12"
  depends_on    = [aws_iam_role_policy_attachment.btaAPIOperate]

  environment {
    variables = {
      INSTANCE_ID = aws_instance.bta.id
    }
  }
}

resource "aws_lambda_function" "btaAPIAuthAdmin" {
  filename      = "${path.module}/../lambdas/btaAPIAuthAdmin.zip"
  function_name = "btaAPIAuthAdmin"
  role          = aws_iam_role.btaAPIAuthAdmin.arn
  handler       = "lambda_handler.lambda_handler"
  runtime       = "python3.12"
  depends_on    = [aws_iam_role_policy_attachment.btaAPIAuthAdmin]

  environment {
    variables = {
      SECRET_ID = aws_secretsmanager_secret.btaAPIAuthTOTPKey.id
    }
  }
}
