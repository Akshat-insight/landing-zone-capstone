variable "environment" {
  description = "Environment label e.g. dev, test, prod"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the identity is created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "identity_name" {
  description = "Name of the user-assigned managed identity"
  type        = string
}

variable "scope_resource_group_id" {
  description = "Resource ID of the resource group this identity should be scoped to (least privilege)"
  type        = string
}

variable "role_definition_name" {
  description = "Azure RBAC role to assign to the identity, scoped to the resource group"
  type        = string
  default     = "Contributor"
}