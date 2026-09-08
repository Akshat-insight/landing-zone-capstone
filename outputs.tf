output "hub_vnet_id" {
  description = "Resource ID of the hub VNet"
  value       = module.hub_network.hub_vnet_id
}

output "spoke_vnet_ids" {
  description = "Map of spoke environment to VNet ID"
  value       = { for k, v in module.spoke_network : k => v.vnet_id }
}

output "spoke_subnet_ids" {
  description = "Map of spoke environment to its subnet IDs"
  value       = { for k, v in module.spoke_network : k => v.subnet_ids }
  sensitive   = true
}

output "key_vault_uris" {
  description = "Map of spoke environment to Key Vault URI"
  value       = { for k, v in module.data_secrets : k => v.key_vault_uri }
}