# creating security group
resource "azurerm_network_security_group" "abdelSG1-test" {
  name                = "testAcceptanceSG1"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.abdelRG1-test.name}"

  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}

resource "azurerm_network_security_rule" "SG1-outbound1" {
  name                        = "test-allow-outbound-rule"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.abdelRG1-test.name}"
  network_security_group_name = "${azurerm_network_security_group.abdelSG1-test.name}"
}

resource "azurerm_network_security_rule" "sshRule" {
  name                        = "test-allow-Inbound-rule"
  priority                    = 111
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.abdelRG1-test.name}"
  network_security_group_name = "${azurerm_network_security_group.abdelSG1-test.name}"
}

resource "azurerm_network_security_rule" "httpRule" {
  name                        = "HTTP"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.abdelRG1-test.name}"
  network_security_group_name = "${azurerm_network_security_group.abdelSG1-test.name}"
}

resource "azurerm_network_security_rule" "httpsRule" {
  name                        = "HTTPS"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.abdelRG1-test.name}"
  network_security_group_name = "${azurerm_network_security_group.abdelSG1-test.name}"
}
