# modules/app-gateway/variables.tf
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
  description = "Subnet ID for Application Gateway"
}

variable "capacity" {
  type        = number
  description = "Number of Application Gateway capacity units"
  default     = 2
}

variable "enable_https" {
  type        = bool
  description = "Enable HTTPS listener and routing"
  default     = false
}

variable "ssl_certificate_data" {
  type        = string
  description = "SSL certificate data in PFX format (base64 encoded)"
  sensitive   = true
}

variable "ssl_certificate_password" {
  type        = string
  description = "Password for SSL certificate"
  sensitive   = true
}

#variable "aks_agic_identity_principal_id" {
#  type        = string
#  description = "Principal ID of AKS AGIC managed identity"
#}

variable "min_capacity" {
  type        = number
  description = "Minimum capacity for autoscaling"
  default     = 2
}

variable "max_capacity" {
  type        = number
  description = "Maximum capacity for autoscaling"
  default     = 10
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}