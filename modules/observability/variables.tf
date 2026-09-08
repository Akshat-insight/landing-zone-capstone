variable "environment" {
  description = "Environment label e.g. dev, test, prod"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for this spoke's observability resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
}

variable "nsg_ids" {
  description = "Map of NSG name to NSG resource ID, for diagnostic settings"
  type        = map(string)
  default     = {}
}

variable "firewall_id" {
  description = "Resource ID of the hub firewall, for diagnostic settings (optional - only set on the module call that owns the hub)"
  type        = string
  default     = null
}

variable "enable_firewall_diagnostics" {
  description = "Whether to create firewall diagnostic settings (plain boolean, avoids count-on-unknown-value issue)"
  type        = bool
  default     = false
}
