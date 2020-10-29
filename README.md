# AWS lambda with API gateway

AWS services used:

* AP Gateway
* Lambda
* IAM

## About

Basic 'hello world' Lambda which can be executed via either GET / or GET /hello to the external API hostname, which is randomly generated upon deployment.

e.g https://XXXX.execute-api.us-east-1.amazonaws.com/ or https://XXXX.execute-api.us-east-1.amazonaws.com/hello

This project does not contain the actual Lambda code itself, and that's located in a seperate repo (python-hello-world-lambda).

This forms part of a end to end deployment of API Gateway and Lambda via Jenkins.

If you wish to deploy as-is, then you will require the code from this repo plus 'lambda_function_payload.zip' in your present working directory. 

lambda_function_payload.zip is simply a zip of the python-hello-world-lambda/hello-world.py.


