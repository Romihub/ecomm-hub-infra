# modules/aks/outputs.tf
output "cluster_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "The ID of the AKS cluster"
}

output "cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "The name of the AKS cluster"
}

output "kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Raw Kubernetes config for connecting to the cluster"
}

#output "identity_principal_id" {
#  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
#  description = "The Principal ID of the AKS cluster's managed identity"
#}

output "identity_object_id" {
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
  description = "The Object ID of the AKS cluster's managed identity"
}

output "node_resource_group" {
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
  description = "The resource group containing AKS cluster nodes"
}

