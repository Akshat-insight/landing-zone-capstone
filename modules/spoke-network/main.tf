# Spoke Virtual Network
resource "azurerm_virtual_network" "spoke" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
}

# Route Table — forces spoke traffic through the hub firewall (only created if create_route_table is true)
resource "azurerm_route_table" "spoke" {
  count               = var.create_route_table ? 1 : 0
  name                = "rt-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  route {
    name                   = "default-via-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = "${var.environment}-${each.key}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [each.value.address_prefix]
}

# NSGs with dynamic security rules
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.subnets
  name                = "nsg-${var.environment}-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = each.value.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = var.subnets
  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

# Associate Route Table with subnets (only if route table was created)
resource "azurerm_subnet_route_table_association" "rt_assoc" {
  for_each       = var.create_route_table ? var.subnets : {}
  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = azurerm_route_table.spoke[0].id
}