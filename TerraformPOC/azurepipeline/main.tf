resource "azurerm_resource_group" "rg" {
    name     = var.rg
    location = var.location
}

resource "azurerm_app_service_plan" "service_plan" {
    name    = "service_plan"
    location = azurerm_resource_group.my_rg.location
    resource_group_name = azurerm_resource_group.rg.name

    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "terraform-app-service" {
    name = "terraform-app-service"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    app_service_plan_id = azurerm_app_service.plan.service_plan.app_service_plan_id

    site_config {
        dotnet_framework_version = "v4.0"
        scm_type = "LocalGit"
    }

    app_settings = {
        "SOME_KEY" = "some-value"
    }

    connection_string {
        name = "Database"
        type = "SQL_Server"
        value = "Server=tcp:${azurerm_sql_server.sql_server.fully_qualified_domain_name"
    }
}

resource "azurerm_sql_server" "sql_server" {
    name = "terraform-sqlserver"
    resource_group_name = azurerm_resource_group.rg.name
    location  = azurerm_resource_group.rg.location
    version = "12.0"
    administrator_login = ""
    administrator_login_password = ""
}

resource "azure_sql_database" "sql_db" {
    name = "terraform-sqldb"
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    server_name = azure_sql_database.sql_db.name
    
    tags = {
        environment = "dev"
    }
}


