provider "aws" {
  region = var.region
}

resource "aws_instance" "ec2_instance1" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = var.instance_count
}

resource "aws_instance" "ec2_instance2" {
  ami           = var.ami
  instance_type = var.instance_type
  count         = var.instance_count
}