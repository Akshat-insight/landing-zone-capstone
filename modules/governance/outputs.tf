output "allowed_regions_policy_id" {
  description = "Resource ID of the allowed regions policy definition"
  value       = azurerm_policy_definition.allowed_regions.id
}

output "require_tag_policy_id" {
  description = "Resource ID of the required tag policy definition"
  value       = azurerm_policy_definition.require_tag.id
}