# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_access_key" {
  description = "The access key name"
  type        = string
  default     = ""
}

variable "aws_secret_key" {
  description = "The secret key name"
  type        = string
  default     = ""
}

variable "environment_name" {
  description = "The environment name"
  type        = string
}

variable "key_name" {
  description = "The key name"
  type        = string
  default     = ""
}

variable "region" {
  default = "us-east-2"
}

variable "versioning" {
  type        = bool
  description = "(Optional) A state of versioning."
  default     = true
}


variable "sse_algorithm" {
  type        = string
  description = "(required) The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  default     = "AES256"
}

variable "aws_iam_role" {
  type        = string
  description = "IAM Role name for replication"
  default     = "s3crr-iam"
}

variable "destinationBucket" {
  type        = string
  description = "IAM Role name for replication"
  default     = "destination-b1-demo"
}

variable "sourceBucket" {
  type        = string
  description = "IAM Role name for replication"
  default     = "source-b1-demo"
}


