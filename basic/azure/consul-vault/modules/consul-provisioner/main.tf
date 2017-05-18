##
resource "azurerm_network_interface" "consul-interface" {
  name                = "${var.cbox_naming_prefix}${var.cbox_comp_name}NetworkInterfaceHost"
  location            = "${var.cbox_azure_location}"
  resource_group_name = "${var.cbox_resource_group_name}"

  ip_configuration {
    name = "${var.cbox_naming_prefix}${var.cbox_comp_name}NetworkInterfaceHostIpConf${count.index}"

    #subnet_id                     = "${var.cbox_subnet_private_id}"
    subnet_id                     = "${azurerm_subnet.consul-subnet1.id}"
    private_ip_address_allocation = "dynamic"

    ## To be be removed when adding beyond VPN box
    public_ip_address_id = "${azurerm_public_ip.consul.id}"
  }

  # All tags should be prefixed with cb_ so that its obvious the resources
  # were created via CloudBot 
  tags {
    Name             = "${var.cbox_naming_prefix}${var.cbox_comp_name}NetworkInterfaceHost${count.index}"
    cb_project       = "${var.cbox_project_name}"
    cb_cbox_name     = "${var.cbox_name}"
    cb_cbox_env_role = "${var.cbox_env_role}"
  }
}

resource "azurerm_virtual_machine" "consul-host" {
  name                          = "${var.cbox_naming_prefix}${var.cbox_comp_name}${var.cbox_vm_prefix}${format("%02d", count.index + 1)}"
  location                      = "${var.cbox_azure_location}"
  resource_group_name           = "${var.cbox_resource_group_name}"
  network_interface_ids         = ["${element(azurerm_network_interface.consul-interface.*.id,count.index)}"]
  vm_size                       = "${var.cbox_vm_size}"
  delete_os_disk_on_termination = true
  count                         = "${var.cbox_vm_count}"

  # TODO make this less hard-coded
  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.3"
    version   = "latest"
  }

  storage_os_disk {
    name = "${var.cbox_naming_prefix}${var.cbox_comp_name}${var.cbox_vm_prefix}${format("%02d", count.index + 1)}disk"

    #vhd_uri       = "${var.cbox_storage_vhd_uri}/${var.cbox_naming_prefix}${var.cbox_comp_name}${var.cbox_vm_prefix}${format("%02d", count.index + 1)}disk.vhd"
    vhd_uri       = "${azurerm_storage_account.consulcboxsa.primary_blob_endpoint}${azurerm_storage_container.consul-sc.name}/disk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.cbox_vm_prefix}${format("%02d", count.index + 1)}"
    admin_username = "${var.cbadmin_user_username}"
    #admin_password = "${random_id.cbadmin-password.b64}"
    admin_password = "${var.cbadmin_user_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false

    #disable_password_authentication = true
    #ssh_keys {
    #  path     = "/home/cbadmin/.ssh/authorized_keys"
    #  key_data = "${var.cbadmin_user_public_key_openssh}"
    #}
  }

  # All tags should be prefixed with cb_ so that its obvious the resources
  # were created via CloudBot
  tags {
    Name             = "${var.cbox_naming_prefix}${var.cbox_comp_name}${var.cbox_vm_prefix}${format("%02d", count.index + 1)}"
    cb_project       = "${var.cbox_project_name}"
    cb_cbox_name     = "${var.cbox_name}"
    cb_cbox_env_role = "${var.cbox_vm_role}"
  }
}

# This gives an error due to the limitation of the generated password not having 
# any special character as part of the generated password, I guess it may need more
# parameters to set the exact criteria of the generated password (NOT USED Currently)

resource "random_id" "cbadmin-password" {
  byte_length = 8
}

resource "null_resource" "hostdetails" {
  count = "${var.cbox_vm_count}"

  triggers {
    azure_resource_name = "${element(azurerm_virtual_machine.consul-host.*.name,count.index)}"
    hostname            = "${var.cbox_vm_prefix}${format("%02d", count.index + 1)}"
    host_ip             = "${element(azurerm_network_interface.consul-interface.*.private_ip_address,count.index)}"
  }
}

#---------------------------------
# creating Consul resource group
#---------------------------------

#Create Storage account 
resource "azurerm_storage_account" "consulcboxsa" {
  #name                = "${var.cbox_naming_prefix}${var.cbox_comp_name}storageAccountConsul"
  name                = "consul1cboxsa"
  resource_group_name = "${var.cbox_resource_group_name}"
  location            = "${var.cbox_azure_location}"
  account_type        = "Standard_LRS"

  tags {
    Name             = "${var.cbox_naming_prefix}${var.cbox_comp_name}storageAccountConsul"
    cb_project       = "${var.cbox_project_name}"
    cb_cbox_name     = "${var.cbox_name}"
    cb_cbox_env_role = "${var.cbox_env_role}"
  }
}

# Create Storage Container
resource "azurerm_storage_container" "consul-sc" {
  name                  = "vhds"
  resource_group_name   = "${var.cbox_resource_group_name}"
  storage_account_name  = "${azurerm_storage_account.consulcboxsa.name}"
  container_access_type = "private"
}

# Create a virtual network 
resource "azurerm_virtual_network" "consul-vnet" {
  name                = "${var.cbox_naming_prefix}${var.cbox_comp_name}VNetConsul"
  address_space       = ["${var.cbox_virtual_network_cidr}"]
  location            = "${var.cbox_azure_location}"
  resource_group_name = "${var.cbox_resource_group_name}"

  tags {
    Name             = "${var.cbox_naming_prefix}${var.cbox_comp_name}VNetConsul"
    cb_project       = "${var.cbox_project_name}"
    cb_cbox_name     = "${var.cbox_name}"
    cb_cbox_env_role = "${var.cbox_env_role}"
  }
}

# Create Public IP, DELETE this section when adding it behind the vpn server
resource "azurerm_public_ip" "consul" {
  name                         = "${var.cbox_naming_prefix}${var.cbox_comp_name}PublicIpConsul"
  location                     = "${var.cbox_azure_location}"
  resource_group_name          = "${var.cbox_resource_group_name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "${var.cbox_naming_prefix}${var.cbox_comp_name}-cboxconsul"

  # All tags should be prefixed with cb_ so that its obvious the resources
  # were created via CloudBot
  tags {
    Name             = "${var.cbox_naming_prefix}${var.cbox_comp_name}PublicIpConsul"
    cb_project       = "${var.cbox_project_name}"
    cb_cbox_name     = "${var.cbox_name}"
    cb_cbox_env_role = "${var.cbox_env_role}"
  }
}

# Create Frontend Consul subnet
resource "azurerm_subnet" "consul-subnet1" {
  name                 = "${var.cbox_naming_prefix}${var.cbox_comp_name}subnetConsul"
  resource_group_name  = "${var.cbox_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.consul-vnet.name}"
  address_prefix       = "10.0.1.0/24"
}

# creating security group
resource "azurerm_network_security_group" "consul-sg" {
  name                = "${var.cbox_naming_prefix}${var.cbox_comp_name}secgroupConsul"
  location            = "${var.cbox_azure_location}"
  resource_group_name = "${var.cbox_resource_group_name}"

  tags {
    Name             = "${var.cbox_naming_prefix}${var.cbox_comp_name}secgroupConsul"
    cb_project       = "${var.cbox_project_name}"
    cb_cbox_name     = "${var.cbox_name}"
    cb_cbox_env_role = "${var.cbox_env_role}"
  }
}

resource "azurerm_network_security_rule" "consul-sg-outbound1" {
  name                        = "test-allow-outbound-rule"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.cbox_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.consul-sg.name}"
}

resource "azurerm_network_security_rule" "sshRule" {
  name                        = "SSH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "TCP"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.cbox_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.consul-sg.name}"
}

resource "azurerm_network_security_rule" "httpRule" {
  name                        = "HTTP"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.cbox_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.consul-sg.name}"
}

resource "azurerm_network_security_rule" "httpsRule" {
  name                        = "HTTPS"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.cbox_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.consul-sg.name}"
}

resource "azurerm_network_security_rule" "httpsRule2" {
  name                        = "HTTPS2"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.cbox_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.consul-sg.name}"
}

resource "azurerm_network_security_rule" "consulrule1" {
  name                        = "HTTP-HTTPS-Consul"
  priority                    = 150
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "8300-8600"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.cbox_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.consul-sg.name}"
}

resource "azurerm_network_security_rule" "denyRule" {
  name                        = "deny-all"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.cbox_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.consul-sg.name}"
}
