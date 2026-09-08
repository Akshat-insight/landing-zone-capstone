# Key Vault — RBAC authorization mode (not access-policy mode)
resource "azurerm_key_vault" "kv" {
  name                      = var.key_vault_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  tenant_id                 = var.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true
  purge_protection_enabled  = false # set true for real prod environments

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

# Storage Account
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_replication_type

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}