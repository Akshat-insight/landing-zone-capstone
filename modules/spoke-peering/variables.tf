variable "spoke_name" {
  description = "Name label for this spoke, used in peering resource names"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group of the hub VNet"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet"
  type        = string
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub VNet"
  type        = string
}

variable "spoke_resource_group_name" {
  description = "Resource group of the spoke VNet"
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the spoke VNet"
  type        = string
}

variable "spoke_vnet_id" {
  description = "Resource ID of the spoke VNet"
  type        = string
}

variable "use_remote_gateways" {
  description = "Whether the spoke should use the hub's VPN/ER gateway (only valid if hub has a gateway deployed)"
  type        = bool
  default     = false
}