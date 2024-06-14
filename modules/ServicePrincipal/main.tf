data "azuread_client_config" "current" {}

resource "azuread_application" "SPNApp" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "SPN" {
  client_id                    = azuread_application.SPNApp.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "SPNPassword" {
  service_principal_id = azuread_service_principal.SPN.object_id
  
}
