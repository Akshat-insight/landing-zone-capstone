output "firewall_id" {
  description = "Resource ID of the hub firewall"
  value       = var.deploy_firewall ? azurerm_firewall.hub[0].id : null
}