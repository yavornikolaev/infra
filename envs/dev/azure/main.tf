module "azure_network" {
  source = "../../../modules/azure_network"

  name_prefix = local.name_prefix
  location    = local.location
  vnet_cidr   = "10.20.0.0/16"
  subnet_cidr = "10.20.1.0/24"
  tags        = local.tags
}

module "azure_vm" {
  source = "../../../modules/azure_vm"

  name                = "test"
  location            = local.location
  resource_group_name = module.azure_network.resource_group_name
  subnet_id           = module.azure_network.subnet_id

  vm_size        = "Standard_D2als_v7"
  admin_username = "ubuntu"
  ssh_public_key = file(pathexpand("~/YavorVM_key.pem.pub"))

  os_disk_size_gb   = 30
  enable_public_ip  = true
  create_nsg        = true
  allow_http        = true
  ssh_source_cidrs  = ["0.0.0.0/0"]
  http_source_cidrs = ["0.0.0.0/0"]

  image_publisher = "Canonical"
  image_offer     = "ubuntu-24_04-lts"
  image_sku       = "server"
  image_version   = "latest"

  tags = local.tags
}
