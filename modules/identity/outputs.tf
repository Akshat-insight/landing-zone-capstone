output "identity_id" {
  description = "Resource ID of the user-assigned identity"
  value       = azurerm_user_assigned_identity.spoke_identity.id
}

output "identity_principal_id" {
  description = "Principal (object) ID of the identity — used for further role assignments, e.g. Key Vault access"
  value       = azurerm_user_assigned_identity.spoke_identity.principal_id
}

output "identity_client_id" {
  description = "Client ID of the identity — used when assigning it to a VM/App Service"
  value       = azurerm_user_assigned_identity.spoke_identity.client_id
}