provider "azurerm" {
  features {}
  subscription_id                 = "24ac5026-bbe5-4647-98b3-55541c9d5ff9"
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "genai_rg" {
  name     = "genai-resource-group"
  location = "West Europe"
}

resource "azurerm_virtual_network" "genai_vnet" {
  name                = "genai-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.genai_rg.location
  resource_group_name = azurerm_resource_group.genai_rg.name
}

resource "azurerm_subnet" "genai_subnet" {
  name                 = "genai-subnet"
  resource_group_name  = azurerm_resource_group.genai_rg.name
  virtual_network_name = azurerm_virtual_network.genai_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "genai_public_ip" {
  name                = "genai-public-ip"
  location            = azurerm_resource_group.genai_rg.location
  resource_group_name = azurerm_resource_group.genai_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "genai_nic" {
  name                = "genai-nic"
  location            = azurerm_resource_group.genai_rg.location
  resource_group_name = azurerm_resource_group.genai_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.genai_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.genai_public_ip.id
  }
}

resource "azurerm_network_security_group" "genai_nsg" {
  name                = "genai-nsg"
  location            = azurerm_resource_group.genai_rg.location
  resource_group_name = azurerm_resource_group.genai_rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "genai_nic_nsg" {
  network_interface_id      = azurerm_network_interface.genai_nic.id
  network_security_group_id = azurerm_network_security_group.genai_nsg.id
}


resource "azurerm_linux_virtual_machine" "genai_vm" {
  name                  = "genai-vm"
  location              = azurerm_resource_group.genai_rg.location
  resource_group_name   = azurerm_resource_group.genai_rg.name
  size                  = "Standard_B1ls" # free-tier VM size
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.genai_nic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "genai-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
