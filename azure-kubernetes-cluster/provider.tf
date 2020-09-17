/* terraform {
  backend "azurerm" {
    resource_group_name  = "playground"
    storage_account_name = "tfbackendge123asb"
    container_name       = "tfbackend"
    key                  = "terraform.tfstate"
  }
} */

variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}

provider "azurerm" {
  features {}
}

/* provider "azuread" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  version         = "~> 0.6"

}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {

}
 */