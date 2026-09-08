# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# Diagnostic settings for each NSG
resource "azurerm_monitor_diagnostic_setting" "nsg_diag" {
  for_each                   = var.nsg_ids
  name                       = "diag-${each.key}"
  target_resource_id         = each.value
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  log {
    category = "NetworkSecurityGroupEvent"
    enabled  = true
  }

  log {
    category = "NetworkSecurityGroupRuleCounter"
    enabled  = true
  }
}

# Diagnostic settings for the hub firewall (only created if enable_firewall_diagnostics is true)
resource "azurerm_monitor_diagnostic_setting" "firewall_diag" {
  count                      = var.enable_firewall_diagnostics ? 1 : 0
  name                       = "diag-firewall"
  target_resource_id         = var.firewall_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true
  }
}