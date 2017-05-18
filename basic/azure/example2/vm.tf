#
# Create Virtual Machine
resource "azurerm_virtual_machine" "abdelVM-test1-centos" {
  name                  = "abdel-centosVM-${count.index}"
  location              = "${var.location}"
  count                 = "${var.vmcount}"
  vm_size               = "Standard_A0"
  depends_on            = ["azurerm_virtual_network.abdelVNet1-test"]
  resource_group_name   = "${azurerm_resource_group.abdelRG1-test.name}"
  network_interface_ids = ["${azurerm_network_interface.abdel-nic1.id}"]

  # availability_set_id = "${azurerm_availability_set.availability_set.id}"  
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  #  storage_image_reference {
  #    publisher = "OpenLogic"
  #    offer     = "CentOS"
  #    sku       = "7.2"
  #    version   = "7.2.20170105"
  #  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.3"
    version   = "latest"
  }
  storage_os_disk {
    name          = "centosvm-disk1"
    vhd_uri       = "${azurerm_storage_account.abdelstorageaccount1test.primary_blob_endpoint}${azurerm_storage_container.abdel-storageContainer1-test.name}/centosvm-disk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  os_profile {
    computer_name  = "abdel-terraform"
    admin_username = "testadmin"

    #admin_password = "${var.admin-password}"
    admin_password = "${random_id.admin-password.b64}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}

resource "random_id" "admin-password" {
  byte_length = 8
}
