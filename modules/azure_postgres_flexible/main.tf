terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}

resource "random_password" "admin" {
  count            = var.admin_password == null ? 1 : 0
  length           = 20
  special          = true
  override_special = "_@%"
}

locals {
  admin_password_value = var.admin_password != null ? var.admin_password : random_password.admin[0].result
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgres_version
  administrator_login    = var.admin_username
  administrator_password = local.admin_password_value

  sku_name   = var.sku_name
  storage_mb = var.storage_gb * 1024

  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup == "Enabled"
  auto_grow_enabled            = var.storage_autogrow == "Enabled"

  public_network_access_enabled = true
  zone                          = var.availability_zone

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_ip" {
  for_each = toset(var.allowed_ips)

  name             = "allow-${replace(each.value, ".", "-")}"
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = each.value
  end_ip_address   = each.value
}
