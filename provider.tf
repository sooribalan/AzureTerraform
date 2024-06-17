terraform {
   backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"          # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "abcd1234"                              # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    use_msi              = true                                   # Can also be set via `ARM_USE_OIDC` environment variable.
    client_id            = "188fff17-a701-46a0-b5cc-66f73513521f"  # Can also be set via `ARM_CLIENT_ID` environment variable.
    subscription_id      = "736f8140-d7a6-40ec-86b4-9e3da5fc8382"  # Can also be set via `ARM_SUBSCRIPTION_ID` environment variable.
    tenant_id            = "06155f75-47a2-44dd-9324-7f35f30a5fbe"  # Can also be set via `ARM_TENANT_ID` environment variable.
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
