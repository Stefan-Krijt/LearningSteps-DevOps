# =============================================================================
# PostgreSQL Flexible Server — Externally Managed
# =============================================================================
# The original PostgreSQL server (psql-learningsteps-lokiyna78be3) is stuck
# in "Stopped" state due to an Azure platform issue
# (ServerBusyWithOtherOperation). Azure Support intervention is required
# to clear it.
#
# A point-in-time restore was performed to create psql-learningsteps-restored,
# which is now the active database for the LearningSteps API.
#
# The database is managed externally (not by Terraform) for this deployment.
# In a production environment, the server would be Terraform-managed, and
# this file would contain the azurerm_postgresql_flexible_server resource.
# =============================================================================
