# =============================================================================
# PostgreSQL Flexible Server (Private)
# =============================================================================

resource "random_password" "postgres" {
  length           = 24
  special          = true
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  override_special = "_-"
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                = "psql-${var.project_name}-${var.unique_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  version    = "14"
  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768

  administrator_login    = var.postgres_admin_user
  administrator_password = random_password.postgres.result

  delegated_subnet_id           = azurerm_subnet.db.id
  private_dns_zone_id           = azurerm_private_dns_zone.postgres.id
  public_network_access_enabled = false

  zone = "1"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres]

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "app" {
  name      = "learning_journal"
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
