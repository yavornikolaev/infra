locals {
  env = "dev"

  tags = {
    Environment = local.env
    Project     = "infra"
    ManagedBy   = "terraform"
  }

  user_data_path = "${path.module}/user-data/cloud-init.sh"

}