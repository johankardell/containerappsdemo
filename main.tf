# Cosmosdb must be placed in a RG in the same region as the resourse - otherwise there are problems when cosmosdb 
# resources are low in the region where the RG is deployed (!)
resource "azurerm_resource_group" "demo-cosmosdb" {
  location = local.location_cosmosdb
  name     = "rg-cosmos-demo"
}

resource "azurerm_resource_group" "demo-containerapps" {
  location = local.location_compute
  name     = "rg-containerapps-demo"
}

resource "azurerm_log_analytics_workspace" "demo" {
  location            = azurerm_resource_group.demo-containerapps.location
  name                = "log-containerapps-demo"
  resource_group_name = azurerm_resource_group.demo-containerapps.name
}
