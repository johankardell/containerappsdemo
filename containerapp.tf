
resource "azapi_resource" "container_app_environment" {
  name      = "appenv-demo"
  location  = local.location_compute
  parent_id = azurerm_resource_group.demo-containerapps.id
  type      = "Microsoft.App/managedEnvironments@2022-03-01"
  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.demo.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.demo.primary_shared_key
        }
      }
      vnetConfiguration = {
        internal = false
      }
    }
  })
}


resource "azapi_resource" "helloworld" {
  name      = "helloworld"
  location  = azurerm_resource_group.demo-containerapps.location
  parent_id = azurerm_resource_group.demo-containerapps.id
  type      = "Microsoft.App/containerApps@2022-03-01"
  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.container_app_environment.id
      configuration = {
        ingress = {
          targetPort = 80
          external   = true
        }
      }
      template = {
        containers = [
          {
            image = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
            name  = "helloworld"
        }]
        scale : {
          maxReplicas = 10
          minReplicas = 1
        }
      }
    }
    }
  )
}

resource "azapi_resource" "catsanddogs" {
  name      = "catsanddogs"
  location  = azurerm_resource_group.demo-containerapps.location
  parent_id = azurerm_resource_group.demo-containerapps.id
  type      = "Microsoft.App/containerApps@2022-03-01"

  body = jsonencode({
    properties = {
      managedEnvironmentId = azapi_resource.container_app_environment.id
      configuration = {
        ingress = {
          targetPort = 80
          external   = true
        }
      }
      template = {
        containers = [
          {
            image = "mcr.microsoft.com/azuredocs/azure-vote-front:cosmosdb"
            name  = "azure-vote-front"
            env = [
              {
                name  = "COSMOS_DB_ENDPOINT"
                value = azurerm_cosmosdb_account.cosmos.endpoint
              },
              {
                name  = "COSMOS_DB_MASTERKEY"
                value = azurerm_cosmosdb_account.cosmos.primary_key
              }
            ]
          },
        ]
        scale : {
          maxReplicas = 10
          minReplicas = 1
        }
      }
    }
  })
}
