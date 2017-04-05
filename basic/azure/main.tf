provider "azurerm" {
}

# creating a resource group
resource "azurerm_resource_group" "abdelRG1-test" {
  name     = "${var.resource_group}"
  location = "${var.location}"

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
#  resource_group_name = "${var.resource_group}"

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "subnet3"
    address_prefix = "10.0.3.0/24"
  }
}







#resource "azurerm_virtual_machine" "abdelVM-test1" {

#}


#resource "azurerm_storage_account" "abdelSA-test1" {

#}


#resource "azurerm_storage_blob" "abdelSB-test1" {
#
#}

