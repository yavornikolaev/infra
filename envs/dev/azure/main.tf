module "azure_network" {
  source = "../../../modules/azure_network"

  name_prefix = local.name_prefix
  location    = local.location
  vnet_cidr   = "10.20.0.0/16"
  subnet_cidr = "10.20.1.0/24"
  tags        = local.tags
}

#module "azure_vm" {
#  source = "../../../modules/azure_vm"
#
#  name                = "test"
#  location            = local.location
#  resource_group_name = module.azure_network.resource_group_name
#  subnet_id           = module.azure_network.subnet_id
#
#  vm_size        = "Standard_D2als_v7"
#  admin_username = "ubuntu"
#  ssh_public_key = file(pathexpand("~/YavorVM_key.pem.pub"))
#
#  os_disk_size_gb   = 30
#  enable_public_ip  = true
#  create_nsg        = true
#  allow_http        = true
#  ssh_source_cidrs  = ["0.0.0.0/0"]
#  http_source_cidrs = ["0.0.0.0/0"]
#
#  image_publisher = "Canonical"
#  image_offer     = "ubuntu-24_04-lts"
#  image_sku       = "server"
#  image_version   = "latest"
#
#  tags = local.tags
#}

module "azure_aks" {
  source = "../../../modules/azure_aks"

  name                = "${local.name_prefix}-aks"
  location            = local.location
  resource_group_name = module.azure_network.resource_group_name
  dns_prefix          = "${local.name_prefix}-aks"
  subnet_id           = module.azure_network.subnet_id

  kubernetes_version = "1.33.6"

  node_vm_size         = "Standard_D2als_v7"
  node_count           = 1
  node_min_count       = 1
  node_max_count       = 3
  node_os_disk_size_gb = 30

  node_pools = [
    {
      name                = "devnodepool"
      vm_size             = "Standard_D2als_v7"
      node_count          = 1
      min_count           = 1
      max_count           = 3
      os_disk_size_gb     = 30
      mode                = "User"
      enable_auto_scaling = true
      vnet_subnet_id      = module.azure_network.subnet_id
    }
  ]

  tags = local.tags
}

module "argocd" {
  source = "../../../modules/argocd"

  values_file = "${path.module}/helm-values/argocd-values.yaml"
}

module "postgres" {
  source = "../../../modules/azure_postgres_flexible"

  name                = local.db_name
  location            = local.db_location
  resource_group_name = module.azure_network.resource_group_name
  database_name       = "appdb"
  admin_username      = local.db_admin_username
  postgres_version    = local.db_postgres_ver
  sku_name            = local.db_sku_name
  storage_gb          = local.db_storage_gb
  availability_zone   = local.db_availability_z
  backup_retention_days = local.db_backup_ret_days
  geo_redundant_backup  = local.db_geo_backup
  allowed_ips         = local.db_allowed_ips

  tags = local.tags
}

resource "local_file" "kubeconfig" {
  filename = "${path.module}/kubeconfig.yaml"
  content  = module.azure_aks.kube_config_raw
}

output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}
