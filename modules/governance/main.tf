# Policy Definition — restrict resource deployment to allowed regions
resource "azurerm_policy_definition" "allowed_regions" {
  name         = "allowed-regions-policy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Allowed regions for resource deployment"

  policy_rule = jsonencode({
    if = {
      not = {
        field = "location"
        in    = var.allowed_regions
      }
    }
    then = {
      effect = "deny"
    }
  })
}

# Policy Assignment — applied at subscription scope
resource "azurerm_subscription_policy_assignment" "allowed_regions" {
  name                 = "allowed-regions-assignment"
  policy_definition_id = azurerm_policy_definition.allowed_regions.id
  subscription_id      = "/subscriptions/${var.subscription_id}"
  display_name         = "Enforce allowed regions"
}

# Policy Definition — require a specific tag on all resources
resource "azurerm_policy_definition" "require_tag" {
  name         = "require-tag-policy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require ${var.required_tag_name} tag on resources"

  policy_rule = jsonencode({
    if = {
      field  = "tags[${var.required_tag_name}]"
      exists = "false"
    }
    then = {
      effect = "deny"
    }
  })
}

# Policy Assignment — applied at subscription scope
resource "azurerm_subscription_policy_assignment" "require_tag" {
  name                 = "require-tag-assignment"
  policy_definition_id = azurerm_policy_definition.require_tag.id
  subscription_id      = "/subscriptions/${var.subscription_id}"
  display_name         = "Enforce required tag"
}