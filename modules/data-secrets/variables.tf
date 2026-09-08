variable "environment" {
  description = "Environment label e.g. dev, test, prod"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for this spoke's data resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "key_vault_name" {
  description = "Globally unique Key Vault name"
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique storage account name (lowercase letters and numbers only)"
  type        = string
}

variable "storage_account_tier" {
  description = "Storage account performance tier"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "tenant_id" {
  description = "Azure AD tenant ID for the Key Vault"
  type        = string
}