output "vnet_id" {
  description = "Resource ID of the spoke VNet"
  value       = azurerm_virtual_network.spoke.id
}

output "vnet_name" {
  description = "Name of the spoke VNet"
  value       = azurerm_virtual_network.spoke.name
}

output "subnet_ids" {
  description = "Map of subnet name to subnet ID"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "nsg_ids" {
  description = "Map of NSG name to NSG ID"
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.id }
}