# =============================================================================
# IAM Role Assignments for GitHub Actions OIDC
# =============================================================================
# Grants the GitHub Actions App Registration the permissions it needs to:
#   - Manage resources in the resource group (Contributor)
#   - Push images to ACR (AcrPush)
#   - Deploy to AKS (AKS Cluster User Role)
#
# These are managed in Terraform so that a full destroy + apply cycle
# restores the CI/CD pipeline's permissions without manual intervention.
# =============================================================================

variable "github_actions_sp_object_id" {
  description = "Object ID of the GitHub Actions App Registration's service principal"
  type        = string
}

# Contributor on the resource group
resource "azurerm_role_assignment" "github_actions_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = var.github_actions_sp_object_id
}

# AcrPush on the Azure Container Registry
resource "azurerm_role_assignment" "github_actions_acr_push" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = var.github_actions_sp_object_id
}

# AKS Cluster User Role on the Kubernetes cluster
resource "azurerm_role_assignment" "github_actions_aks_user" {
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = var.github_actions_sp_object_id

  lifecycle {
    # Azure returns the scope with lowercase "resourcegroups" in the path,
    # while Terraform generates it with capital "resourceGroups". Ignore
    # this case-only difference to avoid unnecessary replacement.
    ignore_changes = [scope]
  }
}

# AcrPull for the AKS kubelet identity (so AKS nodes can pull from ACR)
resource "azurerm_role_assignment" "aks_kubelet_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
