
#############################################################################
# VARIABLES
#############################################################################
variable "resource_group_name" {
  type = string
}
variable "location" {
  type    = string
  default = "northeurope"
}
variable "vnet_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}
variable "subnet1_prefix" {
  type    = string
  default = "10.0.0.0/24"
}

variable "subnet2_prefix" {
  type    = string
  default = "10.0.1.0/24"
}


variable "subnet1_name" {
  type    = string
  default = "web"
}

variable "subnet2_name" {
  type    = string
  default = "database"
}


#############################################################################
# PROVIDERS
#############################################################################
provider "azurerm" {
}
#############################################################################
# RESOURCES
#############################################################################

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.resource_group_name}"
  location = var.location
  tags = {
    project = "Terraform"
    costcenter  = "it"

  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.resource_group_name}"
  address_space       = [var.vnet_cidr_range]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    project = "Terraform"
    costcenter  = "it"
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "sub-${var.subnet1_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix = var.subnet1_prefix
}

resource "azurerm_subnet" "subnet2" {
  name                 = "sub-${var.subnet2_name}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix = var.subnet2_prefix
}

#############################################################################
# OUTPUTS
#############################################################################
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
