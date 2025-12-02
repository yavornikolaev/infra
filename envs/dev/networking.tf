module "networking" {
  source = "../../stacks/networking"

  project_name = var.project_name
  env          = var.env

  cidr = "10.0.0.0/16"

  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  # Няма NAT → Free-tier friendly
  private_subnets = []
  enable_nat_gateway = false
}
