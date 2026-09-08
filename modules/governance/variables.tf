variable "subscription_id" {
  description = "Subscription ID to assign policies against"
  type        = string
}

variable "allowed_regions" {
  description = "List of Azure regions allowed for resource deployment"
  type        = list(string)
  default     = ["East US", "West Europe"]
}

variable "required_tag_name" {
  description = "Name of the tag that must be present on all resources"
  type        = string
  default     = "environment"
}