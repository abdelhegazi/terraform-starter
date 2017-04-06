provider "azurerm" {}

# creating a resource group
resource "azurerm_resource_group" "abdelRG1-test" {
  name     = "${var.resource_group}"
  location = "${var.location}"

  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}

# creating security group
resource "azurerm_network_security_group" "abdelSG1-test" {
  name                = "testAcceptanceSG1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.abdelRG1-test.name}"

  security_rule {
    name                       = "allow-rule"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}

# Create a virtual network 
resource "azurerm_virtual_network" "abdelVNet-test1" {
  name                = "abdelVNet-test1"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.abdelRG1-test.name}"

  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}

resource "azurerm_subnet" "abdelSN1-test" {
  name                 = "abdelSN1-test"
  resource_group_name  = "${azurerm_resource_group.abdelRG1-test.name}"
  virtual_network_name = "${azurerm_virtual_network.abdelVNet-test1.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "abdelSN2-test" {
  name                 = "abdelSN2-test"
  resource_group_name  = "${azurerm_resource_group.abdelRG1-test.name}"
  virtual_network_name = "${azurerm_virtual_network.abdelVNet-test1.name}"
  address_prefix       = "10.0.2.0/24"
}

# Create Virtual Machine
#resource "azurerm_virtual_machine" "abdelVM-test1-windows" {
#  depends_on = ["azurerm_virtual_network.abdelVNet-test1"]
#  name       = "abdeltf-windows"
#}


#resource "azurerm_storage_account" "abdelSA-test1" {


#}


#resource "azurerm_storage_blob" "abdelSB-test1" {
#
#}

