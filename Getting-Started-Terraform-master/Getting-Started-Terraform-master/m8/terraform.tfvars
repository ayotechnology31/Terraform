# IAM Access and Secret Key for your IAM user
aws_access_key = "AKIA3C5BJDJEEHRU224H"

aws_secret_key = "QOUxKjl8kHKKNX93T/M4p2RDgWKoTsUX6LVAj/kS"

# Name of the key pair in AWS, MUST be in same region as EC2 instance
# Check README for AWS CLI commands to create a key pair
key_name = "TestKeyPair3"

# Local path to pem file for key pair. 
# Windows paths need to use double-backslash: Ex. C:\\Users\\Ned\\Pluralsight.pem
private_key_path = "/Users/cookie/.ssh/TestKeyPair3.pem" 

# Prefix value to be used for S3 bucket. You can leave this value as-is
bucket_name_prefix = "globo"

# Environment tag for all resources being created. You can leave this value as-is.
environment_tag = "dev"

# Made up billing code to be added as a tag to resources. You can leave this value as-is.
billing_code_tag = "ACCT8675309"

# You will need to create a service principal
# Check the README for instructions
arm_subscription_id = "f69342c6-d96f-4b40-8d53-7073326f6db4"

# This will be the appId from the service principal creation
arm_principal = "48cd0f72-251a-4af1-bdda-0e5d9001117d"

arm_password = "I2nHH5oY.CDi8oU~HG0XLet8s4I.tNQsPk"

tenant_id = "181fc68a-1c44-434a-8c38-08de13b47cb1"

dns_zone_name = "contoso.xyz"

dns_resource_group = "MyResourceGroup"

network_address_space = {
  Development = "10.0.0.0/16"
  UAT = "10.1.0.0/16"
  Production = "10.2.0.0/16"
}

instance_size = {
  Development = "t2.micro"
  UAT = "t2.small"
  Production = "t2.medium"
}

subnet_count = {
  Development = 2
  UAT = 2
  Production = 3
}

instance_count = {
  Development = 2
  UAT = 4
  Production = 6
}
