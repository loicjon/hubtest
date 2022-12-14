resource "azurerm_virtual_network_peering" "hub-spoke1" {
  name                      = "peer1to2"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.spoke1Vnet.id
}


resource "azurerm_virtual_network_peering" "spoke1-hub" {
  name                      = "peer2to1"
  resource_group_name       = var.resource_group_name_spoke1
  virtual_network_name      = var.virtual_network_name_spoke
  remote_virtual_network_id = azurerm_virtual_network.hubVnet.id
}