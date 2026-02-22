output "resource_group_name" {
  value       = azurerm_resource_group.this.name
  description = "Resource group name."
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.this.id
  description = "Virtual network ID."
}

output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "Subnet ID."
}

output "subnet_name" {
  value       = azurerm_subnet.this.name
  description = "Subnet name."
}
