data "azurerm_client_config" "current-account" {}

output "account_id" {
  value = "${data.azurerm_client_config.current-account.account_id}"
}

# Security Group ID
output "abdelSG1-id" {
  value = "${azurerm_network_security_group.abdelSG1-test.id}"
}

# Frontend subnet name
output "abdelSN1-FE-name" {
  value = "${azurerm_subnet.abdelSN1-FE.name}"
}

# Frontend subnet ID
output "abdelSN1-FE-id" {
  value = "${azurerm_subnet.abdelSN1-FE.id}"
}

# Backend subnet name
output "abdelSN1-BE-name" {
  value = "${azurerm_subnet.abdelSN1-BE.name}"
}

# Backend subnet ID
output "abdelSN1-BE-id" {
  value = "${azurerm_subnet.abdelSN1-BE.id}"
}

# publicIP ID
output "bdel-pubip1-id" {
  value = "${azurerm_public_ip.abdel-pubip1-test.id}"
}

# publicIP address
output "bdel-pubip1-address" {
  value = "${azurerm_public_ip.abdel-pubip1-test.ip_address}"
}

# publicIP FQDN
output "bdel-pubip1-fqdn" {
  value = "${azurerm_public_ip.abdel-pubip1-test.fqdn}"
}
