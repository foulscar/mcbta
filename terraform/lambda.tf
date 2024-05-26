resource "aws_lambda_function" "btaAPIOperate" {
  filename      = data.archive_file.btaAPIOperate.output_path
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
  filename      = data.archive_file.btaAPIAuthAdmin.output_path
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
