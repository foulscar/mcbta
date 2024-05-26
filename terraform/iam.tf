resource "aws_iam_role" "btaAPIOperate" {
  name               = "btaAPIOperate"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

data "aws_iam_policy_document" "btaAPIOperate" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:StartInstances",
      "ec2:StopInstances"
    ]

    resources = [aws_instance.bta.arn]
  }
}

resource "aws_iam_policy" "btaAPIOperate" {

  name        = "btaAPIOperate"
  description = "AWS IAM Policy for btaAPIOperate Lambda"
  policy      = data.aws_iam_policy_document.btaAPIOperate.json
}

resource "aws_iam_role_policy_attachment" "btaAPIOperate" {
  role       = aws_iam_role.btaAPIOperate.name
  policy_arn = aws_iam_policy.btaAPIOperate.arn
}

resource "aws_iam_role" "btaAPIAuthAdmin" {
  name               = "btaAPIAuthAdmin"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

data "aws_iam_policy_document" "btaAPIAuthAdmin" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [aws_secretsmanager_secret.btaAPIAuthTOTPKey.arn]
  }
}

resource "aws_iam_policy" "btaAPIAuthAdmin" {

  name        = "btaAPIAuthAdmin"
  description = "AWS IAM Policy for btaAPIAuthAdmin Lambda"
  policy      = data.aws_iam_policy_document.btaAPIAuthAdmin.json
}

resource "aws_iam_role_policy_attachment" "btaAPIAuthAdmin" {
  role       = aws_iam_role.btaAPIAuthAdmin.name
  policy_arn = aws_iam_policy.btaAPIAuthAdmin.arn
}
