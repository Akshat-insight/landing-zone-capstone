terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstatelz"
    container_name       = "tfstate"
    key                  = "landing-zone.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Hub Resource Group
resource "azurerm_resource_group" "hub_rg" {
  name     = var.hub_resource_group_name
  location = var.location

  lifecycle {
    prevent_destroy = true
  }
}

# Hub Network
module "hub_network" {
  source                 = "./modules/hub-network"
  resource_group_name    = azurerm_resource_group.hub_rg.name
  location               = var.location
  hub_vnet_name          = var.hub_vnet_name
  hub_address_space      = var.hub_address_space
  firewall_subnet_prefix = "10.0.1.0/26"
  bastion_subnet_prefix  = "10.0.2.0/27"
  gateway_subnet_prefix  = "10.0.3.0/27"
  deploy_firewall        = var.deploy_firewall
  deploy_bastion         = var.deploy_bastion
  deploy_vpn_gateway     = var.deploy_vpn_gateway
}

# Spoke Resource Groups
resource "azurerm_resource_group" "spoke_rg" {
  for_each = var.spokes
  name     = "rg-spoke-${each.key}"
  location = var.location
}

# Spoke Networks
module "spoke_network" {
  source              = "./modules/spoke-network"
  for_each            = var.spokes
  environment         = each.key
  resource_group_name = azurerm_resource_group.spoke_rg[each.key].name
  location            = var.location
  vnet_name           = "vnet-spoke-${each.key}"
  vnet_address_space  = each.value.address_space
  subnets             = each.value.subnets
  firewall_private_ip = var.deploy_firewall ? module.hub_network.firewall_private_ip : null
  create_route_table  = var.deploy_firewall
}

# Peering — hub to each spoke
module "peering" {
  source                    = "./modules/spoke-peering"
  for_each                  = var.spokes
  spoke_name                = each.key
  hub_resource_group_name   = azurerm_resource_group.hub_rg.name
  hub_vnet_name             = module.hub_network.hub_vnet_name
  hub_vnet_id               = module.hub_network.hub_vnet_id
  spoke_resource_group_name = azurerm_resource_group.spoke_rg[each.key].name
  spoke_vnet_name           = module.spoke_network[each.key].vnet_name
  spoke_vnet_id             = module.spoke_network[each.key].vnet_id
  use_remote_gateways       = var.deploy_vpn_gateway
}

# Data & Secrets — one Key Vault + Storage per spoke
module "data_secrets" {
  source               = "./modules/data-secrets"
  for_each             = var.spokes
  environment          = each.key
  resource_group_name  = azurerm_resource_group.spoke_rg[each.key].name
  location             = var.location
  key_vault_name       = "kv-lz-${each.key}-${substr(md5(each.key), 0, 6)}"
  storage_account_name = "stlz${each.key}${substr(md5(each.key), 0, 6)}"
  tenant_id            = var.tenant_id
}

# Observability — one Log Analytics workspace per spoke
module "observability" {
  source                       = "./modules/observability"
  for_each                     = var.spokes
  environment                  = each.key
  resource_group_name          = azurerm_resource_group.spoke_rg[each.key].name
  location                     = var.location
  log_analytics_workspace_name = "law-${each.key}"
  nsg_ids                      = module.spoke_network[each.key].nsg_ids
  firewall_id                  = each.key == "prod" && var.deploy_firewall ? module.hub_network.firewall_id : null
  enable_firewall_diagnostics  = each.key == "prod" && var.deploy_firewall
}

# Identity — one managed identity per spoke, least-privilege scoped
module "identity" {
  source                  = "./modules/identity"
  for_each                = var.spokes
  environment             = each.key
  resource_group_name     = azurerm_resource_group.spoke_rg[each.key].name
  location                = var.location
  identity_name           = "id-${each.key}"
  scope_resource_group_id = azurerm_resource_group.spoke_rg[each.key].id
  role_definition_name    = "Contributor"
}

# Governance — policy assignments (subscription scope)
module "governance" {
  source          = "./modules/governance"
  subscription_id = var.subscription_id
}