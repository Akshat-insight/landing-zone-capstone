variable "environment" {
  description = "Environment label e.g. dev, test, prod"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for this spoke"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Name of the spoke VNet"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the spoke VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnet configurations with NSG rules"
  type = map(object({
    address_prefix = string
    nsg_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

variable "firewall_private_ip" {
  description = "Private IP of the hub firewall — used as next hop for the default route. Set to null to skip route table creation."
  type        = string
  default     = null
}