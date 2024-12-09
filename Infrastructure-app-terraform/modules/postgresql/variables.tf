# modules/database/variables.tf
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

variable "environment" {
  type        = string
  description = "Environment (dev/prod)"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for PostgreSQL"
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID for PostgreSQL"
}

variable "sku_name" {
  type        = string
  description = "PostgreSQL SKU name"
}

variable "storage_mb" {
  type        = number
  description = "Storage size in MB"
}

variable "database_name" {
  type        = string
  description = "Name of the database to create"
}

variable "admin_username" {
  type        = string
  description = "Administrator username"
}

variable "admin_password" {
  type        = string
  description = "Administrator password"
  sensitive   = true
}

variable "enable_connection_pooling" {
  type        = bool
  description = "Enable PgBouncer connection pooling"
  default     = false
}

variable "db_configurations" {
  type        = map(string)
  description = "Map of PostgreSQL configuration settings"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}