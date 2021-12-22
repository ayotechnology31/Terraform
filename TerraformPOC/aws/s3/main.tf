## apply first

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-cl"
  acl    = "log-delivery-write"

cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://s3-website-test.hashicorp.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

 versioning {
    enabled = true
  }

lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      rule      = "log"
      autoclean = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  lifecycle_rule {
    id      = "tmp"
    prefix  = "tmp/"
    enabled = true

    expiration {
      date = "2016-01-12"
    }
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


## add aws_s3_bucket_object to s3 and trigger will appear in function overview

resource "aws_s3_bucket_object" "object" {
  bucket = "my-tf-test-bucket-cl"
  key    = "new_object_key"
  source = "./index.html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
 
    etag = filemd5("./index.html")
}

## apply third time

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Buckets"
  action        = "lambda:InvokeFunction"
  function_name = "arn:aws:lambda:us-east-1:762158062152:function:lambdafunction1"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::my-tf-test-bucket-cl"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "my-tf-test-bucket-cl"

  lambda_function {
    lambda_function_arn = "arn:aws:lambda:us-east-1:762158062152:function:lambdafunction1"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}


#sqs
resource "aws_sqs_queue" "terraform_queue" {
  name                      = "terraform-example-queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10


  tags = {
    Environment = "dev"
  }
}
