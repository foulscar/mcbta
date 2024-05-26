data "archive_file" "btaAPIOperate" {
  type        = "zip"
  source_dir  = "${path.module}/../lambdas/btaAPIOperate"
  output_path = "${path.module}/../lambdas/btaAPIOperate.zip"
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
