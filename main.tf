resource "azurerm_resource_group" "AKSClusterRG" {
  name     = var.rgname
  location = var.location
}

module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name
  depends_on             = [azurerm_resource_group.AKSClusterRG]
}

resource "azurerm_role_assignment" "rolespn" {

  scope                = "/subscriptions/736f8140-d7a6-40ec-86b4-9e3da5fc8382"
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [module.ServicePrincipal]
}

module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

}

resource "azurerm_key_vault_secret" "vaultsecret" {
  name         = module.ServicePrincipal.client_id
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.keyvault.keyvault_id
  
  depends_on = [module.keyvault]
} 

module "aks" {
  source = "./modules/aks"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.location
  resource_group_name    = var.rgname
}