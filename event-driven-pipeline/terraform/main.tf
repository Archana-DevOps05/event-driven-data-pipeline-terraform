terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Raw data bucket
resource "aws_s3_bucket" "raw" {
  bucket = var.raw_bucket_name
  force_destroy = true
}

# Processed data & reports bucket
resource "aws_s3_bucket" "processed" {
  bucket = var.processed_bucket_name
  force_destroy = true
}

# IAM role for Lambda
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "lambda_event_pipeline_role_${random_id.suffix.hex}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "random_id" "suffix" {
  byte_length = 4
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.raw.arn,
      "${aws_s3_bucket.raw.arn}/*",
      aws_s3_bucket.processed.arn,
      "${aws_s3_bucket.processed.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "lambda_policy_attach" {
  name = "lambda_policy_${random_id.suffix.hex}"
  role = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}

# Processor Lambda
resource "aws_lambda_function" "processor" {
  function_name = "edp_data_processor_${random_id.suffix.hex}"
  filename      = var.processor_zip_path
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.11"
  source_code_hash = filebase64sha256(var.processor_zip_path)

  environment {
    variables = {
      PROCESSED_BUCKET = aws_s3_bucket.processed.bucket
    }
  }
}

# Permission for S3 to invoke processor
resource "aws_lambda_permission" "allow_s3_invocation" {
  statement_id  = "AllowS3Invoke_${random_id.suffix.hex}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.raw.arn
}

# S3 notification to Lambda on object created (.json or any)
resource "aws_s3_bucket_notification" "raw_notify" {
  bucket = aws_s3_bucket.raw.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
    # remove filter if you want all files processed
    filter_suffix       = ".json"
  }

  depends_on = [aws_lambda_permission.allow_s3_invocation]
}

# Daily report Lambda
resource "aws_lambda_function" "daily_report" {
  function_name = "edp_daily_report_${random_id.suffix.hex}"
  filename      = var.report_zip_path
  role          = aws_iam_role.lambda_exec.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.11"
  source_code_hash = filebase64sha256(var.report_zip_path)

  environment {
    variables = {
      PROCESSED_BUCKET = aws_s3_bucket.processed.bucket
    }
  }
}

# EventBridge rule to trigger daily report (UTC 00:05)
resource "aws_cloudwatch_event_rule" "daily" {
  name                = "edp_daily_report_rule_${random_id.suffix.hex}"
  schedule_expression = "cron(5 0 * * ? *)"
}

resource "aws_cloudwatch_event_target" "report_target" {
  rule      = aws_cloudwatch_event_rule.daily.name
  target_id = "edp_daily_report_target"
  arn       = aws_lambda_function.daily_report.arn
}

resource "aws_lambda_permission" "allow_events" {
  statement_id  = "AllowEventBridgeInvoke_${random_id.suffix.hex}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.daily_report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily.arn
}

# Outputs
output "raw_bucket" {
  value = aws_s3_bucket.raw.bucket
}

output "processed_bucket" {
  value = aws_s3_bucket.processed.bucket
}

output "processor_lambda" {
  value = aws_lambda_function.processor.arn
}

output "daily_report_lambda" {
  value = aws_lambda_function.daily_report.arn
}
