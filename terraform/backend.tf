# =============================================================================
# Remote State Backend
# =============================================================================
# State is stored in Azure Storage (created by scripts/bootstrap-backend.sh).
# Run `terraform init` to connect to it.
# =============================================================================

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-learningsteps"
    storage_account_name = "sttfstatelokiyn9802"
    container_name       = "tfstate"
    key                  = "learningsteps-devops.tfstate"
  }
}
