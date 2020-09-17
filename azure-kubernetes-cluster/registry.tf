/* resource "azurerm_container_registry" "docker_registry" {
  name                     = "registry123asb"
  resource_group_name      = azurerm_resource_group.azureplayground.name
  location                 = azurerm_resource_group.azureplayground.location
  sku                      = "Basic"
  admin_enabled            = true
}

output "registry_login_server" {
  value = azurerm_container_registry.docker_registry.login_server
}

output "registry_admin_username" {
  value = azurerm_container_registry.docker_registry.admin_username
}

output "registry_admin_password" {
  value = azurerm_container_registry.docker_registry.admin_password
} */
