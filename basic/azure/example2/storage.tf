# Create Storage account
resource "azurerm_storage_account" "abdelstorageaccount1test" {
  name                = "${var.storage-account}"
  resource_group_name = "${azurerm_resource_group.abdelRG1-test.name}"
  location            = "${var.location}"
  account_type        = "Standard_LRS"

  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}

# Create Storage Container
resource "azurerm_storage_container" "abdel-storageContainer1-test" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.abdelRG1-test.name}"
  storage_account_name  = "${azurerm_storage_account.abdelstorageaccount1test.name}"
  container_access_type = "private"
}
