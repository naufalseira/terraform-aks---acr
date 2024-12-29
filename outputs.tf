output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kubernetes_cluster_dns_prefix" {
  value = azurerm_kubernetes_cluster.aks.dns_prefix
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "kubernetes_cluster_kube_config_raw" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}