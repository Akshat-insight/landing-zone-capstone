output "key_vault_id" {
  description = "Resource ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.kv.vault_uri
}

output "storage_account_id" {
  description = "Resource ID of the storage account"
  value       = azurerm_storage_account.sa.id
}