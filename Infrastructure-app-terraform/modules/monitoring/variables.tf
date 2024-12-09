# modules/monitoring/variables.tf
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

variable "aks_cluster_id" {
  type        = string
  description = "AKS cluster ID for monitoring"
}

variable "retention_in_days" {
  type        = number
  description = "Number of days to retain logs"
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}