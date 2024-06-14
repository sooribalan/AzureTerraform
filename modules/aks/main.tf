# Define the virtual network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "vnet-devtest"
  address_space       = ["10.0.0.0/8"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Define the subnet
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.240.0.0/16"]
}

# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
  include_preview = false  
}
 

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                  = "SB-aks-cluster"
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = "${var.resource_group_name}-cluster"           
  kubernetes_version    =  data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"
  
  
  default_node_pool {
    name       = "defaultpool"
    vm_size    = "Standard D2pls v5"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
    enable_auto_scaling  = false
    max_count            = 1
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "environment"      = "dev"
     } 
   tags = {
      "environment"      = "dev"
    
   } 
  }

  service_principal  {
    client_id = var.client_id
    client_secret = var.client_secret
  }

  network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
  }

    
}