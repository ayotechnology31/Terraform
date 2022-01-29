##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

#################################################################################
# RESOURCES FOR SOURCE BUCKET IN EAST 2 REGION
#################################################################################

##SOURCE BUCKET
resource "aws_s3_bucket" "sourceBucket" {
  bucket        = var.sourceBucket
  acl           = "public-read-write"
  force_destroy = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  ##CROSS REPLICATION RULE
  replication_configuration {
    role = aws_iam_role.iam_role.arn
    rules {
      id     = "crossreplicationrule1"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.destinationBucket.arn
        storage_class = "STANDARD_IA"
      }
      priority = "0"
    }
  }

  versioning {
    enabled = var.versioning
  }
  ##TAGS
  tags = {
    Name        = "${var.environment_name}-${var.sourceBucket}"
    Environment = "${var.environment_name}"
  }
}

#################################################################################
# RESOURCES FOR DESTINATION BUCKET IN EAST 2 REGION
#################################################################################

resource "aws_s3_bucket" "destinationBucket" {
  bucket        = var.destinationBucket
  acl           = "private"
  force_destroy = false


  ##VERSIONING
  versioning {
    enabled = var.versioning
  }

  ##KMS
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  ##LIFECYCLE
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
      storage_class = "STANDARD_IA"
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

  ##TAGS
  tags = {
    Name        = "${var.environment_name}-${var.destinationBucket}"
    Environment = "${var.environment_name}"
  }
}

resource "aws_s3_bucket_policy" "sourceBucket" {
  bucket = aws_s3_bucket.sourceBucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:DeleteBucket"
      ],
      "Effect": "Deny",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.sourceBucket.id}",
      "Principal": {
        "AWS": ["*"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "iam_policy" {
  name        = var.aws_iam_role
  description = "IAM replication policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersionAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.destinationBucket.id}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetReplicationConfiguration"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.destinationBucket.id}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags",
                "s3:GetObjectVersionTagging"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.sourceBucket.id}/*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "iam_role" {
  name = var.aws_iam_role


  assume_role_policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Principal":{
            "Service":"s3.amazonaws.com"
         },
         "Action":"sts:AssumeRole"
      }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}