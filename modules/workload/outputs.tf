output "app_service_url" {
  description = "Default hostname of the App Service (null if workload_type is not app_service)"
  value       = var.workload_type == "app_service" ? azurerm_linux_web_app.app[0].default_hostname : null
}