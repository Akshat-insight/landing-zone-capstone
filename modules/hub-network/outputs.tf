output "hub_vnet_id" {
  description = "Resource ID of the hub VNet"
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Name of the hub VNet"
  value       = azurerm_virtual_network.hub.name
}

output "firewall_private_ip" {
  description = "Private IP of the Azure Firewall — used for spoke route tables"
  value       = var.deploy_firewall ? azurerm_firewall.hub[0].ip_configuration[0].private_ip_address : null
}

output "firewall_id" {
  description = "Resource ID of the hub firewall"
  value       = var.deploy_firewall ? azurerm_firewall.hub[0].id : null
}