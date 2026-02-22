output "vm_id" {
  value       = azurerm_linux_virtual_machine.this.id
  description = "Virtual machine ID."
}

output "private_ip" {
  value       = azurerm_network_interface.this.private_ip_address
  description = "Private IP address."
}

output "public_ip" {
  value       = var.enable_public_ip ? azurerm_public_ip.this[0].ip_address : null
  description = "Public IP address (if enabled)."
}

output "nsg_id" {
  value       = var.create_nsg ? azurerm_network_security_group.this[0].id : null
  description = "NSG ID (if created)."
}
