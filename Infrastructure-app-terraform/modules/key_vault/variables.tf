variable "vault_name" {
  type        = string
  description = "Name of the Key Vault"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}

variable "network_acls" {
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  description = "Network ACLs for the Key Vault"
  default = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Enable Key Vault for disk encryption"
  default     = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of days to retain deleted vaults"
  default     = 7
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection"
  default     = false
}

variable "sku_name" {
  type        = string
  description = "SKU name for the Key Vault (standard or premium)"
  default     = "standard"
}