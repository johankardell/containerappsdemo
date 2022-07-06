resource "azurerm_cosmosdb_account" "cosmos" {
  name                      = "cdb-demo-se"
  location                  = azurerm_resource_group.demo-cosmosdb.location
  resource_group_name       = azurerm_resource_group.demo-cosmosdb.name
  offer_type                = "Standard"
  kind                      = "GlobalDocumentDB"
  enable_free_tier          = true
  enable_automatic_failover = false

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = azurerm_resource_group.demo-cosmosdb.location
    failover_priority = 0
  }
}

# resource "azurerm_role_assignment" "func" {
#   scope                = azurerm_cosmosdb_account.cosmos.id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_user_assigned_identity.func.principal_id
# }
