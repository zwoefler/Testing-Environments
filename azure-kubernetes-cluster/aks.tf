variable "aks_hosts" {}
variable "aks_sku" {}
variable "kubernetes_version" {}

# AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-aks"
  location            = azurerm_resource_group.azureplayground.location
  resource_group_name = azurerm_resource_group.azureplayground.name
  dns_prefix          = var.project_name
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name            = var.project_name
    node_count      = var.aks_hosts
    vm_size         = var.aks_sku
    os_disk_size_gb = 30
    max_pods        = 30
    type            = "VirtualMachineScaleSets" #for migration from node_profile
  }

  identity {
    type = "SystemAssigned"
  }


}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}
