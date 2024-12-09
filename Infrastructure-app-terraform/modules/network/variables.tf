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

variable "vnet_cidr" {
  type        = string
  description = "CIDR block for the virtual network"
  validation {
    condition     = can(cidrhost(var.vnet_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "aks_subnet_cidr" {
  type        = string
  description = "CIDR block for the AKS subnet"
  validation {
    condition     = can(cidrhost(var.aks_subnet_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "db_subnet_cidr" {
  type        = string
  description = "CIDR block for the database subnet"
  validation {
    condition     = can(cidrhost(var.db_subnet_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "redis_subnet_cidr" {
  type        = string
  description = "CIDR block for the Redis subnet"
  validation {
    condition     = can(cidrhost(var.redis_subnet_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "appgw_subnet_cidr" {
  type        = string
  description = "CIDR block for the Application Gateway subnet"
  validation {
    condition     = can(cidrhost(var.appgw_subnet_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "private_endpoint_network_policies" {
  type        = string
  description = "Enable or disable network policies for private endpoints"
  #default     = true
}

variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "List of NSG rules"
  default = [
    {
      name                       = "AllowHTTPS"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

variable "dns_servers" {
  type        = list(string)
  description = "List of DNS servers"
  default     = []
}

variable "dns_zones" {
  type = map(object({
    name = string
    links = list(object({
      name               = string
      virtual_network_id = string
    }))
  }))
  description = "Map of private DNS zones and their virtual network links"
  default     = {}
}

variable "service_endpoints" {
  type        = list(string)
  description = "List of service endpoints to enable for the AKS subnet"
  default = [
    "Microsoft.Sql",
    "Microsoft.AzureCosmosDB",
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}

variable "route_table_routes" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  description = "List of routes for the route table"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}