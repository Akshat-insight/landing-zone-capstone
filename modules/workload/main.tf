# App Service Plan + Web App (only created if workload_type = "app_service")
resource "azurerm_service_plan" "asp" {
  count               = var.workload_type == "app_service" ? 1 : 0
  name                = "asp-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku
}

resource "azurerm_linux_web_app" "app" {
  count               = var.workload_type == "app_service" ? 1 : 0
  name                = "app-${var.environment}-${substr(md5(var.environment), 0, 6)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp[0].id

  site_config {}
}

# NOTE: vm and aks workload types are placeholders for future extension.
# Uncomment and complete when needed — kept out of scope for capstone v1
# to avoid unused-resource cost/complexity until actually required.