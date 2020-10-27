terraform {
  required_version = ">=0.12.0"
  required_providers {
    aws = {
      version = ">=3.0.0"
    }
  }
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "aws-terraform-ansible-jenkins-env2"
  }
}


provider "aws" {
  profile = default
  region  = us-east-1
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "hello_world_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_handler"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "exports.test"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "Python 3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
