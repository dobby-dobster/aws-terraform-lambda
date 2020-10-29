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
  function_name = "hello_world_python"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "hello-world.lambda_handler"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

# HTTP API
resource "aws_apigatewayv2_api" "api" {
	name          = "hello_world_python"
	protocol_type = "HTTP"
	target        = aws_lambda_function.hello_world_lambda.arn
}

# Permission
resource "aws_lambda_permission" "apigw" {
	action        = "lambda:InvokeFunction"
	function_name = aws_lambda_function.hello_world_lambda.arn
	principal     = "apigateway.amazonaws.com"

	source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /"
}

resource "aws_apigatewayv2_route" "route_hello" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /hello"
}
