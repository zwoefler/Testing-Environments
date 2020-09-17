variable "project_name" {}

# Create a resource group
resource "azurerm_resource_group" "azureplayground" {
  name     = var.project_name
  location = "westeurope"
}

# for tf backen
/* resource "azurerm_storage_account" "tfbackend" {
  name                     = "tfbackendge123asb"
  resource_group_name      = azurerm_resource_group.azureplayground.name
  location                 = azurerm_resource_group.azureplayground.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "infra"
  }
} */

# for tf backen
/* resource "azurerm_storage_container" "tfbackend" {
  name                  = "tfbackend"
  storage_account_name  = azurerm_storage_account.tfbackend.name
  container_access_type = "private"
}
 */