provider "random" {}

resource "random_string" "trigger" {
  length  = 8
  special = false
}

data "archive_file" "btaAPIOperate" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/btaAPIOperate"
  output_path = "${path.module}/../lambdas/btaAPIOperate.zip"

  depends_on = [ random_string.trigger ]
}

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

data "archive_file" "btaAPIAuthAdmin" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/btaAPIAuthAdmin"
  output_path = "${path.module}/../lambdas/btaAPIAuthAdmin.zip"

  depends_on = [ random_string.trigger ]
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
