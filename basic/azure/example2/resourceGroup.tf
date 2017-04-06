# creating a resource group
resource "azurerm_resource_group" "abdelRG1-test" {
  name     = "${var.resource_group}"
  location = "${var.location}"

  tags {
    env    = "abdel-cloudbot-test1"
    client = "abdel-terraform"
  }
}
