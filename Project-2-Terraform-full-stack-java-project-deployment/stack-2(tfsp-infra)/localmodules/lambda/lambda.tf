#--------------------------
# archive python file to zip
#--------------------------
data "archive_file" "tfsp_lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/files/cloudwatch-sns-slack-notification.py"
  output_path = "${path.module}/files/cloudwatch-sns-slack-notification.zip"
}


#-----------------------------
# IAM Role for Lambda Function
#-----------------------------
resource "aws_iam_role" "tfsp_cloudwatch_lambda_role" {
  name = "tfsp-${var.envname}-cloudwatch-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

}

#-----------------------------
# Lambda policy data document
#-----------------------------
data "aws_iam_policy" "tfsp_lambda_basic_execution" {
  name = "AWSLambdaBasicExecutionRole"
}

#-----------------------------
# IAM Role Policy Attachment    
#-----------------------------
resource "aws_iam_policy_attachment" "tfsp_lambda_basic_execution_attach" {
  name       = "tfsp-${var.envname}-lambda-basic-execution"
  roles      = [aws_iam_role.tfsp_cloudwatch_lambda_role.name]
  policy_arn = data.aws_iam_policy.tfsp_lambda_basic_execution.arn
}


#-----------------------------
# Lambda Function   
#-----------------------------
resource "aws_lambda_function" "tfsp_cloudwatch_sns_lambda" {
  function_name    = "tfsp-${var.envname}-cloudwatch-sns-slack-notification"
  role             = aws_iam_role.tfsp_cloudwatch_lambda_role.arn
  handler          = "cloudwatch-sns-slack-notification.lambda_handler"
  runtime          = var.be_cloudwatch_lambda_runtime
  filename         = data.archive_file.tfsp_lambda_zip.output_path
  source_code_hash = data.archive_file.tfsp_lambda_zip.output_base64sha256
  architectures    = ["x86_64"]
  memory_size      = var.be_cloudwatch_lambda_memory_size
  timeout          = var.be_cloudwatch_lambda_timeout
  package_type     = "Zip"
  environment {
    variables = {
      slackHookUrl = var.slack_web_hook_url
    }

  }
}

#-----------------------------
# Lambda Permission for SNS 
#-----------------------------
resource "aws_lambda_permission" "tfsp_sns_invoke_lambda_permission" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tfsp_cloudwatch_sns_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}