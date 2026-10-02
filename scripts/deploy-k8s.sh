#!/bin/bash
# =============================================================================
# Deploy LearningSteps to AKS
# =============================================================================
# This script deploys the Kubernetes manifests, dynamically substituting
# the Key Vault CSI driver's client ID (which changes with each AKS cluster).
#
# Usage:
#   ./scripts/deploy-k8s.sh
#
# Prerequisites:
#   - AKS cluster running
#   - kubectl configured (az aks get-credentials already run)
#   - Key Vault exists with db-* secrets
# =============================================================================

set -e

RESOURCE_GROUP="${RESOURCE_GROUP:-rg-learningsteps-dev}"
AKS_CLUSTER="${AKS_CLUSTER:-aks-learningsteps}"

echo "Fetching CSI driver identity for cluster: $AKS_CLUSTER"

CSI_CLIENT_ID=$(az aks show \
  --resource-group $RESOURCE_GROUP \
  --name $AKS_CLUSTER \
  --query "addonProfiles.azureKeyvaultSecretsProvider.identity.clientId" -o tsv)

if [ -z "$CSI_CLIENT_ID" ]; then
  echo "ERROR: Could not retrieve CSI client ID. Is the CSI driver enabled?"
  exit 1
fi

echo "CSI Client ID: $CSI_CLIENT_ID"

echo ""
echo "Generating temporary manifest with correct CSI identity..."

mkdir -p /tmp/learningsteps-k8s

# Copy and substitute the secretproviderclass
sed "s|userAssignedIdentityID:.*|userAssignedIdentityID: \"$CSI_CLIENT_ID\"|" \
  k8s/secretproviderclass.yaml > /tmp/learningsteps-k8s/secretproviderclass.yaml

# Copy other manifests as-is
cp k8s/deployment.yaml /tmp/learningsteps-k8s/
cp k8s/service.yaml /tmp/learningsteps-k8s/
cp k8s/configmap.yaml /tmp/learningsteps-k8s/
cp k8s/hpa.yaml /tmp/learningsteps-k8s/
cp k8s/schema-job.yaml /tmp/learningsteps-k8s/
cp k8s/schema-configmap.yaml /tmp/learningsteps-k8s/

echo "Applying manifests..."

kubectl apply -f /tmp/learningsteps-k8s/

echo ""
echo "Waiting for API pod to be ready..."

kubectl rollout status deployment/learningsteps-api --timeout=180s

echo ""
echo "Waiting for schema job to complete..."

kubectl wait --for=condition=complete job/learningsteps-schema-init --timeout=120s

echo ""
echo "✅ Deployment complete!"
echo ""
echo "API endpoint:"
kubectl get svc learningsteps-api
