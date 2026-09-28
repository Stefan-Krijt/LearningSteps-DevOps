# =============================================================================
# Input Variables
# =============================================================================

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "westeurope"
}

variable "project_name" {
  description = "Project name used as prefix for resource names"
  type        = string
  default     = "learningsteps"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "unique_suffix" {
  description = "Unique suffix for globally-unique resource names (e.g. ACR, Key Vault)"
  type        = string
  # No default — must be set in terraform.tfvars
}

variable "ssh_public_key" {
  description = "SSH public key content for AKS Linux nodes"
  type        = string
  # No default — must be set in terraform.tfvars
}

variable "aks_node_count" {
  description = "Initial number of nodes in the AKS node pool"
  type        = number
  default     = 1
}

variable "aks_node_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v6"
}

variable "postgres_admin_user" {
  description = "PostgreSQL administrator username"
  type        = string
  default     = "dbadmin"
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    project     = "learningsteps"
    managed_by  = "terraform"
    environment = "dev"
  }
}
