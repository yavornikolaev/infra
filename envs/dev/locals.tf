locals {
  env = "dev"

  tags = {
    Environment = local.env
    ManagedBy   = "terraform"
  }
}
###test string##########21212