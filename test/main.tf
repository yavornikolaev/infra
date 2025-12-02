terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Fetch latest Ubuntu AMI (passed into module)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

module "vpc" {
  source = "../modules/vpc"

  name = "demo"
}

resource "aws_security_group" "ssh" {
  name   = "allow-ssh"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (test environment)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

module "public_ec2" {
  source = "../modules/ec2"

  instance_count      = 1
  instance_type       = "t2.micro"
  ami_id              = data.aws_ami.ubuntu.id
  key_name            = "yavor-ec2"      
 
  subnet_id           = module.vpc.public_subnet_id
  security_group_ids  = [aws_security_group.ssh.id]
  associate_public_ip = true

  root_volume_size    = 8
  root_volume_type    = "gp3"

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from Terraform!" > /tmp/test.txt
  EOF

  name_prefix = "public-ec2"
  tags = {
    Environment = "Test"
    Owner       = "DevOps"
  }
}
