#!/bin/bash
# =============================================================================
# Terraform Remote State Backend Bootstrap
# =============================================================================
# One-time setup: creates the storage account that will hold Terraform state.
# Run this once before `terraform init`.
# =============================================================================

set -e

# =============================================================================
# Configuration
# =============================================================================

# Unique suffix for globally-unique names (storage accounts must be globally unique)
UNIQUE_SUFFIX="${USER}$(date +%s | tail -c 5)"

# Resource names
RG_NAME="rg-tfstate-learningsteps"
LOCATION="westeurope"
STORAGE_ACCOUNT="sttfstate${UNIQUE_SUFFIX}"     # 3-24 chars, lowercase alphanumeric
CONTAINER_NAME="tfstate"

# =============================================================================
# Pre-flight checks
# =============================================================================

echo "Checking Azure CLI login..."
if ! az account show &>/dev/null; then
    echo "You are not logged into Azure. Running 'az login'..."
    az login
fi

CURRENT_SUB=$(az account show --query id -o tsv)
echo "Using subscription: $CURRENT_SUB"
echo ""

# =============================================================================
# Create resource group
# =============================================================================

echo "Creating resource group: $RG_NAME"
az group create \
    --name "$RG_NAME" \
    --location "$LOCATION" \
    --output none

# =============================================================================
# Create storage account
# =============================================================================

echo "Creating storage account: $STORAGE_ACCOUNT"
az storage account create \
    --name "$STORAGE_ACCOUNT" \
    --resource-group "$RG_NAME" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --encryption-services blob \
    --min-tls-version TLS1_2 \
    --allow-blob-public-access false \
    --output none

# =============================================================================
# Create blob container
# =============================================================================

echo "Creating blob container: $CONTAINER_NAME"
az storage container create \
    --name "$CONTAINER_NAME" \
    --account-name "$STORAGE_ACCOUNT" \
    --auth-mode login \
    --output none

# =============================================================================
# Print results (you'll copy these into backend.tf)
# =============================================================================

echo ""
echo "═══════════════════════════════════════════════════════════════════════"
echo "              Terraform Backend Bootstrap Complete                    "
echo "═══════════════════════════════════════════════════════════════════════"
echo ""
echo "  Resource Group:    $RG_NAME"
echo "  Storage Account:   $STORAGE_ACCOUNT"
echo "  Container:         $CONTAINER_NAME"
echo "  Location:          $LOCATION"
echo ""
echo "═══════════════════════════════════════════════════════════════════════"
echo ""
echo "  ▶ Copy these values into terraform/backend.tf"
echo ""
echo "═══════════════════════════════════════════════════════════════════════"
