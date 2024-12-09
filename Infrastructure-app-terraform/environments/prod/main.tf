resource "azurerm_resource_group" "main" {
  name     = "ecom-prod-rg"
  location = "uksouth"
  tags = {
    Environment = "Production"
    Project     = "E-commerce"
  }
}

# Networking
module "network" {
  .....
  tags = {
    Environment = "Production"
    Project     = "E-commerce"
  }
}
...
#To be completed