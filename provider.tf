terraform {

  backend "azurerm" {
    resource_group_name  = "jenkins"  
    storage_account_name = "aksstorage7305"                      
    container_name       = "tfstate"                       
    key                  = "prod.terraform.tfstate"

  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.107.0"
    }
  }
}

provider "azurerm" {
  features {}

}