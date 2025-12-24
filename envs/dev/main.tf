module "vpc" {
  source = "../../modules/vpc"

  name     = local.env
  vpc_cidr = "10.10.0.0/16"

  public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnet_cidrs = ["10.10.101.0/24", "10.10.102.0/24"]
  availability_zones   = ["eu-central-1a", "eu-central-1b"]

  ##IMPORTANT: disabled NAT for reduce
  enable_nat_gateway = false

  tags = local.tags
}

module "ec2_iam" {
  source = "../../modules/iam"

  role_name = "${local.env}-ec2-ssm-role"
  tags      = local.tags
}

module "ec2_sg" {
  source = "../../modules/sg"

  name   = "${local.env}-ec2"
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
      description = "HTTP access"
    }
  ]

  tags = local.tags
}

module "ec2" {
  source                = "../../modules/ec2"
  name_prefix           = "${local.env}-ec2"
  instance_count        = 1
  instance_type         = "t2.micro"
  instance_profile_name = module.ec2_iam.instance_profile_name

  subnet_id = module.vpc.public_subnet_ids[0]

  security_group_ids = [module.ec2_sg.security_group_id]
  key_name           = null
  root_volume_size   = 8
  ## user_data = file("${path.module}/user-data/cloud-init.sh")

  tags = local.tags
}