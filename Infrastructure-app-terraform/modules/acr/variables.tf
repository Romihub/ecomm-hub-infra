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
  description = "Subnet ID for private endpoint"
}

variable "vnet_id" {
  type        = string
  description = "Virtual network ID for DNS zone link"
}

#variable "aks_principal_id" {
#  type        = string
#  description = "Principal ID of AKS managed identity"
#}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID for diagnostics"
}

variable "geo_replications" {
  type        = list(string)
  description = "List of Azure regions for ACR geo-replication"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}