locals {
  env         = "dev"
  name_prefix = "infra-dev"
  location    = "westeurope"

  tags = {
    Environment = local.env
    Project     = "infra"
    ManagedBy   = "terraform"
  }

  db_location        = "northeurope"
  db_name            = "testpostgresss"
  db_admin_username  = "b5zerk"
  db_sku_name        = "B_Standard_B1ms"
  db_storage_gb      = 128
  db_postgres_ver    = "17"
  db_availability_z  = "1"
  db_backup_ret_days = 7
  db_geo_backup      = "Disabled"
  # Set to your public IP (e.g. "203.0.113.10") to allow access.
  db_allowed_ips = ["46.232.159.250"]
}
