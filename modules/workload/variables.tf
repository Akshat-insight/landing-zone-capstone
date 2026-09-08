variable "environment" {
  description = "Environment label e.g. dev, test, prod"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for this workload"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "workload_type" {
  description = "Type of compute to deploy: 'vm', 'app_service', or 'aks'"
  type        = string
  default     = "app_service"

  validation {
    condition     = contains(["vm", "app_service", "aks"], var.workload_type)
    error_message = "workload_type must be one of: vm, app_service, aks."
  }
}

variable "subnet_id" {
  description = "Subnet ID to deploy the workload into"
  type        = string
}

variable "app_service_sku" {
  description = "SKU for App Service Plan (only used if workload_type = app_service)"
  type        = string
  default     = "B1"
}