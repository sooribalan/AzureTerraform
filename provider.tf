terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.107.0"
    }
  }
 backend "azurerm" {
    resource_group_name  = "jenkins"  
    storage_account_name = "aksstorage7305"                      
    container_name       = "tfstate"                       
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
