# modules/aks/variables.tf
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

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for AKS cluster"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID"
}

# System Node Pool Variables
variable "system_node_count" {
  type        = number
  description = "Initial number of nodes for system pool"
}

variable "system_node_vm_size" {
  type        = string
  description = "VM size for system nodes"
}

variable "system_node_min_count" {
  type        = number
  description = "Minimum number of nodes for system pool"
}

variable "system_node_max_count" {
  type        = number
  description = "Maximum number of nodes for system pool"
}

# On-demand Node Pool Variables
variable "ondemand_node_vm_size" {
  type        = string
  description = "VM size for on-demand nodes"
}

variable "ondemand_node_min_count" {
  type        = number
  description = "Minimum number of nodes for on-demand pool"
}

variable "ondemand_node_max_count" {
  type        = number
  description = "Maximum number of nodes for on-demand pool"
}

# Spot Node Pool Variables
variable "spot_node_vm_size" {
  type        = string
  description = "VM size for spot nodes"
}

variable "spot_node_min_count" {
  type        = number
  description = "Minimum number of nodes for spot pool"
}

variable "spot_node_max_count" {
  type        = number
  description = "Maximum number of nodes for spot pool"
}

variable "spot_price_max" {
  type        = number
  description = "Maximum price for spot instances (-1 for market price)"
  default     = -1
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}

variable "appgw_subnet_id" {
  type        = string
  description = "Subnet ID for Application Gateway"
  default     = null
}


variable "key_vault_id" {
  type        = string
  description = "ID of the Key Vault to integrate with AKS"
}

variable "enable_secret_rotation" {
  type        = bool
  description = "Enable automatic rotation of secrets"
  default     = true
}

#variable "secret_rotation_interval" {
#  type        = string
#  description = "Interval for secret rotation"
#  default     = "2m"
#}

variable "enable_keyvault_secrets_store_driver" {
  type        = bool
  description = "Enable Azure Key Vault Secrets Store CSI Driver"
  default     = true
}