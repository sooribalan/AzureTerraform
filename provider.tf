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
subscription_id   = "736f8140-d7a6-40ec-86b4-9e3da5fc8382"
tenant_id         = "06155f75-47a2-44dd-9324-7f35f30a5fbe"
client_id         = "25ba940b-1190-408f-9e70-61005e853c66"
client_secret     = "P5w8Q~QDnUBbFSzdOAVcyq4HnYdq6Tkvn6Rq5cqK"
}
