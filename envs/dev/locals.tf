locals {
  env = "dev"

  tags = {
    Environment = local.env
    Project     = "infra"
    ManagedBy   = "terraform"
  }
}