# Terraform registry --> USE PROVIDER

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

}

# aws_ami data source terraform
data "aws_ami" "tf_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "izmir" {
  ami             = data.aws_ami.tf_ami.id
  instance_type   = var.ins_type
  key_name        = "firstkey"
  count           = length(var.num)
  security_groups = ["tf-provisioner-sg"]
  tags = {
    Name     = "Terraform ${var.num[count.index]} Instance"
  }

  provisioner "local-exec" {
    command = "echo http://${self.public_ip} >> public_ip.txt"
  }
  provisioner "local-exec" {
    command = "echo http://${self.private_ip} >> private_ip.txt"
  }

   connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("firstkey.pem")
  }

   provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum -y install httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "echo 'Hello World' > index.html",
      "sudo cp index.html /var/www/html/"
    ]
  } 

}

resource "aws_security_group" "tf-sec-gr" {
  name = "tf-provisioner-sg"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

