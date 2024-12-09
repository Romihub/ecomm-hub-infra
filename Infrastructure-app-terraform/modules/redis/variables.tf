variable "prefix" {
  type        = string
  description = "Prefix for all resources"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for Redis Cache"
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID for Redis Cache"
}

variable "capacity" {
  type        = number
  description = "Redis cache capacity (0-6)"
  validation {
    condition     = var.capacity >= 0 && var.capacity <= 6
    error_message = "Capacity must be between 0 and 6."
  }
}

variable "family" {
  type        = string
  description = "Redis cache family (C or P)"
  validation {
    condition     = contains(["C", "P"], var.family)
    error_message = "Family must be either 'C' (Standard) or 'P' (Premium)."
  }
}

variable "sku_name" {
  type        = string
  description = "Redis cache SKU (Basic, Standard, Premium)"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_name)
    error_message = "SKU must be either Basic, Standard, or Premium."
  }
}

variable "maxmemory_reserved" {
  type        = number
  description = "Redis maxmemory reserved (MB)"
}

variable "maxmemory_delta" {
  type        = number
  description = "Redis maxmemory delta (MB)"
}

variable "maxmemory_policy" {
  type        = string
  description = "Redis maxmemory policy"
  default     = "allkeys-lru"
}

variable "enable_non_ssl_port" {
  type        = bool
  description = "Enable non-SSL port (6379)"
  default     = false
}

variable "minimum_tls_version" {
  type        = string
  description = "Minimum TLS version"
  default     = "1.2"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}