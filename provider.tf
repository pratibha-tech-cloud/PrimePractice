terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "=5.0.0"
      }
    }
}
provider "azurerm" {
  features {}
  subscription_id = var.subid
}
output "resourceblock" {
    value = azurerm_resource_group.rsblock.name
}
output "vnetblock" {
  value = azurerm_virtual_network.vnetblock.name
}
output "subnetblock" {
  value = azurerm_subnet.subnetblock.name
}
output "nicblock" {
  value = azurerm_network_interface.nicblock.name
}
output "vmblock" {
  value = azurerm_linux_virtual_machine.vmblock.name
}
output "nsgblock" {
  value = azurerm_network_security_group.nsgblock.name
}