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
  source = "../../../modules/vpc"

  name = "jenkins-vpc"
}

module "sg" {
  source = "../../../modules/sg"
  name   = "jenkins-sg"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Jenkins UI"
    }
  ]
}


module "iam_ssm" {
  source    = "../../../modules/iam"
  role_name = "demo-ssm-role"
}


module "ec2" {
  source = "../../../modules/ec2"

  instance_count        = 1
  instance_type         = "t2.micro"
  ami_id                = data.aws_ami.ubuntu.id
  instance_profile_name = module.iam_ssm.instance_profile_name
  key_name              = "devops_key"

  subnet_id           = module.vpc.public_subnet_id
  security_group_ids  = module.sg.security_group_ids
  associate_public_ip = true

  root_volume_size = 8
  root_volume_type = "gp3"

  name_prefix = "jenkins"
  tags = {
    Environment = "dev"
    Owner       = "DevOps"
  }
}
