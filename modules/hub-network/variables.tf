variable "resource_group_name" {
  description = "Resource group for hub resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet"
  type        = string
}

variable "hub_address_space" {
  description = "Address space for the hub VNet"
  type        = list(string)
}

variable "firewall_subnet_prefix" {
  description = "Address prefix for AzureFirewallSubnet (must be named exactly this)"
  type        = string
}

variable "bastion_subnet_prefix" {
  description = "Address prefix for AzureBastionSubnet (must be named exactly this)"
  type        = string
}

variable "gateway_subnet_prefix" {
  description = "Address prefix for GatewaySubnet (must be named exactly this)"
  type        = string
}

variable "deploy_firewall" {
  description = "Whether to deploy Azure Firewall (cost control toggle)"
  type        = bool
  default     = true
}

variable "deploy_bastion" {
  description = "Whether to deploy Azure Bastion (cost control toggle)"
  type        = bool
  default     = true
}

variable "deploy_vpn_gateway" {
  description = "Whether to deploy VPN Gateway (cost control toggle - expensive, ~$140/mo)"
  type        = bool
  default     = false
}