variable "name" {
  description = "The name of the public IP resource"
  type        = string
}

variable "location" {
  description = "The location/region where the public IP will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the public IP"
  type        = string
}

variable "allocation_method" {
  description = "Defines how the public IP should be allocated. Options are 'Static' or 'Dynamic'"
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "The SKU of the Public IP. Options are 'Basic' or 'Standard'"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}