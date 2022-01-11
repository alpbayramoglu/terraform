terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.69.0"
    }
  }

/*   backend "s3" {
    bucket = "tf-remote-s3-bucket-alp"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
  } */
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "tf-ec2" {
  ami           = var.ec2_ami 
  instance_type = var.ec2_type
  key_name      = "firstkey" 
  tags = {
    Name = "${local.mytag}-local"
  }
}

/* variable "s3_bucket_name" {
  default = "alpp-bucket"
}
resource "aws_s3_bucket" "tf-s3" {
  acl = "private"
  bucket = var.s3_bucket_name
} */


/* resource "aws_s3_bucket" "tf-s3" {
  # bucket = "${var.s3_bucket_name}-${count.index+1}"
  acl    = "private"
  # count = var.num_of_buckets
  # count = var.num_of_buckets != 0 ? var.num_of_buckets : 3
  for_each = toset(var.users)
  bucket = "alp-tf-s3-bucket-${each.value}"
} */

/* resource "aws_iam_user" "new_user"{
  name = each.value
  for_each = toset(var.users)
} */


/* data "aws_ami" "tf_ami" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  ami           = data.aws_ami.tf_ami.id
} */

/* data "aws_ami" "tf_ami" {
  most_recent = true
  owners = ["self"]

filter {
  name = "virtualization-type"
  values = ["hvm"]
} 
}*/

locals {
  mytag = "alp-instance"  
}