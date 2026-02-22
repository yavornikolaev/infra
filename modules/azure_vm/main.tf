locals {
  vm_name     = var.name
  nic_name    = "${var.name}-nic"
  public_name = "${var.name}-pip"
  nsg_name    = var.nsg_name == null ? "${var.name}-nsg" : var.nsg_name
  nsg_id      = var.create_nsg ? azurerm_network_security_group.this[0].id : var.network_security_group_id
  attach_nsg  = var.create_nsg || var.network_security_group_id != null
}

resource "azurerm_network_security_group" "this" {
  count               = var.create_nsg ? 1 : 0
  name                = local.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.ssh_source_cidrs
    destination_address_prefix = "*"
  }

  dynamic "security_rule" {
    for_each = var.allow_http ? [1] : []
    content {
      name                       = "allow-http"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefixes    = var.http_source_cidrs
      destination_address_prefix = "*"
    }
  }

  tags = var.tags
}

resource "azurerm_public_ip" "this" {
  count               = var.enable_public_ip ? 1 : 0
  name                = local.public_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "this" {
  name                = local.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.enable_public_ip ? azurerm_public_ip.this[0].id : null
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "this" {
  count                     = local.attach_nsg ? 1 : 0
  network_interface_id      = azurerm_network_interface.this.id
  network_security_group_id = local.nsg_id
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = local.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username

  disable_password_authentication = var.disable_password_authentication

  network_interface_ids = [azurerm_network_interface.this.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  custom_data = var.custom_data
  tags        = var.tags
}
