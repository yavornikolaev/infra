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

# Create a simple VPC + Subnet for testing (optional)
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "test_subnet" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.10.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "test-public-subnet"
  }
}

resource "aws_security_group" "test_sg" {
  name        = "test-ec2-sg"
  description = "Allow SSH for testing"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ───────────────────────────────────────────────
# Call your EC2 MODULE
# ───────────────────────────────────────────────
module "test_ec2" {
  source = "../modules/ec2"

  instance_count      = 1
  instance_type       = "t3.micro"
  ami_id              = data.aws_ami.ubuntu.id
  key_name            = "yavor-ec2"          # use your real SSH key here
  associate_public_ip = true

  subnet_id           = aws_subnet.test_subnet.id
  security_group_ids  = [aws_security_group.test_sg.id]

  root_volume_size    = 8
  root_volume_type    = "gp3"

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from Terraform!" > /tmp/test.txt
  EOF

  name_prefix = "test-ec2"
  tags = {
    Environment = "Test"
    Owner       = "DevOps"
  }
}
