resource "azurerm_resource_group" "hubGroup" {

  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.tags

}


resource "azurerm_virtual_network" "hubVnet" {

  depends_on = [azurerm_resource_group.hubGroup]

  name                = var.virtual_network_name
  address_space       = var.hub_address_space
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

    subnet {
    name           = "subnet1"
    address_prefix = "10.16.0.64/26"
  }

}


resource "azurerm_resource_group" "spoke1Group" {

  name     = var.resource_group_name_spoke1
  location = var.resource_group_location
  tags     = var.tags

}


# Sql Database


resource "azurerm_sql_server" "spoke1sv" {

  depends_on = [azurerm_resource_group.spoke1Group]

  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name_spoke1
  location                     = var.resource_group_location
  version                      = "12.0"
  administrator_login          = var.login
  administrator_login_password = var.password

  tags = {
    environment = "développement"
  }

}


resource "azurerm_sql_database" "spoke1SqlDb" {

  depends_on = [azurerm_storage_account.azureStoAcc]

  name                = var.sql_database_name
  resource_group_name = var.resource_group_name_spoke1
  location            = var.resource_group_location
  server_name         = azurerm_sql_server.spoke1sv.name

#   extended_auditing_policy {
#     storage_endpoint                        = azurerm_storage_account.azureStoAcc.primary_blob_endpoint
#     storage_account_access_key              = azurerm_storage_account.azureStoAcc.primary_access_key
#     storage_account_access_key_is_secondary = true
#     retention_in_days                       = 6
#   }



  tags = {
    environment = "développement"
  }

}


# Création du compte de stockage

resource "azurerm_storage_account" "azureStoAcc" {

  depends_on = [azurerm_resource_group.spoke1Group]

  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name_spoke1
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

# Création du service plan

resource "azurerm_service_plan" "spoke1SerPlan" {

  depends_on = [azurerm_resource_group.spoke1Group]

  name                = var.service_plan_name
  resource_group_name = var.resource_group_name_spoke1
  location            = var.resource_group_location
  os_type             = "Windows"
  sku_name            = "P1v2"

}

# Création de la function App

resource "azurerm_windows_function_app" "spoke1FuncApp" {

  depends_on = [azurerm_storage_account.azureStoAcc]


  name                = var.windows_function_app_name
  resource_group_name = var.resource_group_name_spoke1
  location            = var.resource_group_location

  storage_account_name       = azurerm_storage_account.azureStoAcc.name
  storage_account_access_key = azurerm_storage_account.azureStoAcc.primary_access_key
  service_plan_id            = azurerm_service_plan.spoke1SerPlan.id

  site_config {}

}

# Création de la Web App

resource "azurerm_windows_web_app" "spoke1WebApp" {

  depends_on = [azurerm_service_plan.spoke1SerPlan]

  name                = var.windows_web_app_name
  resource_group_name = var.resource_group_name_spoke1
  location            = var.resource_group_location
  service_plan_id     = azurerm_service_plan.spoke1SerPlan.id

  site_config {
    always_on = false
    use_32_bit_worker = true
  }

}


resource "azurerm_virtual_network" "spoke1Vnet" {

    depends_on = [azurerm_resource_group.spoke1Group]

  name                = var.virtual_network_name_spoke
  address_space       = var.virtual_network_address
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name_spoke1
}

resource "azurerm_subnet" "spoke1Subnet" {

    depends_on = [azurerm_virtual_network.spoke1Vnet]

  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name_spoke1
  virtual_network_name = var.virtual_network_name_spoke
  address_prefixes     = var.subnet_address

  delegation {
    name = "example-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

}


resource "azurerm_app_service_virtual_network_swift_connection" "connect_swift" {

  app_service_id = azurerm_windows_function_app.spoke1FuncApp.id
  subnet_id      = azurerm_subnet.spoke1Subnet.id

}