resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name                 = "system"
    vm_size              = var.node_vm_size
    vnet_subnet_id       = var.subnet_id
    auto_scaling_enabled = true
    min_count            = var.node_min_count
    max_count            = var.node_max_count
    node_count           = var.node_count
    os_disk_size_gb      = var.node_os_disk_size_gb
    type                 = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = { for np in var.node_pools : np.name => np }

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  os_disk_size_gb       = each.value.os_disk_size_gb
  mode                  = each.value.mode
  vnet_subnet_id        = each.value.vnet_subnet_id
  auto_scaling_enabled  = each.value.enable_auto_scaling
  min_count             = each.value.min_count
  max_count             = each.value.max_count
}
