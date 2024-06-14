variable "rgname" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Location of the resources to be created"
}

variable "service_principal_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "stateRG" {
  type = string
}