resource "azurerm_resource_group" "rsblock" {
  name = var.resourcekanaam
  location = var.locationkanaam
}
resource "azurerm_virtual_network" "vnetblock" {
    depends_on = [ azurerm_resource_group.rsblock ]
  name = var.vnetkanaam
  resource_group_name = var.resourcekanaam
  location = var.locationkanaam
  address_space = var.addspc
}
resource "azurerm_subnet" "subnetblock" {
    depends_on = [ azurerm_virtual_network.vnetblock ]
  name = var.subnetkanaam
  resource_group_name = var.resourcekanaam
  virtual_network_name = var.vnetkanaam
  address_prefixes = var.addpfx
}

resource "azurerm_network_interface" "nicblock" {
    depends_on = [ azurerm_subnet.subnetblock,azurerm_public_ip.pipblock]
  name = var.nickkanaam
  resource_group_name = var.resourcekanaam
  location = var.locationkanaam
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnetblock.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pipblock.id
  }
}
resource "azurerm_linux_virtual_machine" "vmblock" {

  name = var.vmkanaam
  resource_group_name = var.resourcekanaam
  location = var.locationkanaam
  size = var.size
  admin_username = var.username
  admin_password = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nicblock.id
  ]
  os_disk {
    caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "ubuntu-24_04-lts"
    sku = "server"
    version = "latest"
  }
}
resource "azurerm_network_security_group" "nsgblock" {
  depends_on = [ azurerm_resource_group.rsblock ]
  name = var.nsgkanaam
  resource_group_name = var.resourcekanaam
  location = var.locationkanaam

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_public_ip" "pipblock" {
depends_on = [ azurerm_resource_group.rsblock ]
  name = var.pipkanaam
  resource_group_name = var.resourcekanaam
  location = var.locationkanaam
  allocation_method = "Static"
}
resource "azurerm_subnet_network_security_group_association" "associationblock" {
  subnet_id                 = azurerm_subnet.subnetblock.id
  network_security_group_id = azurerm_network_security_group.nsgblock.id
}