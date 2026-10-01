# =============================================================================
# Outputs (shown after terraform apply)
# =============================================================================

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "acr_login_server" {
  description = "Azure Container Registry login server (for docker push)"
  value       = azurerm_container_registry.main.login_server
}

output "acr_name" {
  description = "Azure Container Registry name"
  value       = azurerm_container_registry.main.name
}

output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_resource_group" {
  description = "Resource group containing the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.resource_group_name
}

output "postgres_fqdn" {
  description = "PostgreSQL Flexible Server FQDN (externally managed)"
  value       = "psql-learningsteps-restored.postgres.database.azure.com"
}

output "postgres_database" {
  description = "PostgreSQL database name (externally managed)"
  value       = "learning_journal"
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.main.vault_uri
}

output "get_credentials_command" {
  description = "Command to configure kubectl for the AKS cluster"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}"
}

output "key_vault_csi_client_id" {
  description = "Client ID of the Key Vault CSI driver identity"
  value       = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].client_id
}

output "key_vault_csi_object_id" {
  description = "Object ID of the Key Vault CSI driver identity"
  value       = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].object_id
}
