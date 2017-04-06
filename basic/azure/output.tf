data "azurerm_client_config" "current-account" {}

output "account_id" {
  value = "${data.azurerm_client_config.current-account.account_id}"
}

# Security Group ID
output "abdelSG1-id" {
  value = "${azurerm_network_security_group.abdelSG1-test.id}"
}
