locals {
  env         = "dev"
  name_prefix = "infra-dev"
  location    = "westeurope"

  tags = {
    Environment = local.env
    Project     = "infra"
    ManagedBy   = "terraform"
  }
}
