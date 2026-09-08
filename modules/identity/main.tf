# User-assigned managed identity for this spoke
resource "azurerm_user_assigned_identity" "spoke_identity" {
  name                = var.identity_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# Least-privilege role assignment — scoped only to this spoke's resource group
resource "azurerm_role_assignment" "spoke_rbac" {
  scope                = var.scope_resource_group_id
  role_definition_name = var.role_definition_name
  principal_id         = azurerm_user_assigned_identity.spoke_identity.principal_id
}