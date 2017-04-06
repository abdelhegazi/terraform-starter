# Create a virtual network 
resource "azurerm_virtual_network" "abdelVNet1-test" {
  name                = "abdelVNet-test1"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.abdelRG1-test.name}"

  subnet {
    name           = "abdelSN1-FE"
    address_prefix = "10.0.100.0/24"
  }

  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}

# Create Public IP
resource "azurerm_public_ip" "abdel-pubip1-test" {
  name                         = "abdel-pubip1-test"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.abdelRG1-test.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}

# Create Frontend subnet
resource "azurerm_subnet" "abdelSN1-FE" {
  name                 = "abdelSN1-FE"
  resource_group_name  = "${azurerm_resource_group.abdelRG1-test.name}"
  virtual_network_name = "${azurerm_virtual_network.abdelVNet1-test.name}"
  address_prefix       = "10.0.1.0/24"
}

# Create Backend subnet
resource "azurerm_subnet" "abdelSN1-BE" {
  name                 = "abdelSN1-BE"
  resource_group_name  = "${azurerm_resource_group.abdelRG1-test.name}"
  virtual_network_name = "${azurerm_virtual_network.abdelVNet1-test.name}"
  address_prefix       = "10.0.100.0/24"
}

# Create Network Interface
resource "azurerm_network_interface" "abdel-nic1" {
  name                = "abdel-nic1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.abdelRG1-test.name}"

  ip_configuration {
    name                          = "abdel-nic1-configurations"
    subnet_id                     = "${azurerm_subnet.abdelSN1-FE.id}"
    private_ip_address_allocation = "dynamic"

    #private_ip_address            = "10.0.1.2"
    public_ip_address_id = "${azurerm_public_ip.abdel-pubip1-test.id}"
  }

  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}
