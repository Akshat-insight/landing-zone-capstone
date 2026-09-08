variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "East US"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group for hub resources"
  type        = string
  default     = "rg-hub-landingzone"
}

variable "hub_vnet_name" {
  description = "Name of the hub VNet"
  type        = string
  default     = "vnet-hub"
}

variable "hub_address_space" {
  description = "Address space for the hub VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "deploy_firewall" {
  type    = bool
  default = true
}

variable "deploy_bastion" {
  type    = bool
  default = true
}

variable "deploy_vpn_gateway" {
  type    = bool
  default = false
}

variable "spokes" {
  description = "Map of spoke environments to create"
  type = map(object({
    address_space = list(string)
    subnets = map(object({
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
  }))

  default = {
    dev = {
      address_space = ["10.1.0.0/16"]
      subnets = {
        web = {
          address_prefix = "10.1.1.0/24"
          nsg_rules = [
            {
              name = "Allow-HTTP", priority = 100, direction = "Inbound", access = "Allow"
              protocol = "Tcp", source_port_range = "*", destination_port_range = "80"
              source_address_prefix = "*", destination_address_prefix = "*"
            }
          ]
        }
      }
    }
    test = {
      address_space = ["10.2.0.0/16"]
      subnets = {
        web = {
          address_prefix = "10.2.1.0/24"
          nsg_rules = [
            {
              name = "Allow-HTTP", priority = 100, direction = "Inbound", access = "Allow"
              protocol = "Tcp", source_port_range = "*", destination_port_range = "80"
              source_address_prefix = "*", destination_address_prefix = "*"
            }
          ]
        }
      }
    }
    prod = {
      address_space = ["10.3.0.0/16"]
      subnets = {
        web = {
          address_prefix = "10.3.1.0/24"
          nsg_rules = [
            {
              name = "Allow-HTTP", priority = 100, direction = "Inbound", access = "Allow"
              protocol = "Tcp", source_port_range = "*", destination_port_range = "80"
              source_address_prefix = "*", destination_address_prefix = "*"
            }
          ]
        }
      }
    }
  }
}