resource "azurerm_resource_group" "AKSClusterRG" {
  name     = var.rgname
  location = var.location
}
