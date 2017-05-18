# --------
# Output 
# --------

output "Consul_startup_msg" {
  value = <<EOL
 
----------------------------------------------
       Consul Config & Setup instructions
----------------------------------------------

  EOL
}

output "consul_public_ip" {
  value = "${azurerm_public_ip.consul.ip_address}"
}

output "consul_public_fqdn" {
  value = "${azurerm_public_ip.consul.fqdn}"
}

output "consul_private_fqdn" {
  value = "${azurerm_network_interface.consul-interface.internal_fqdn}"
}

output "consul_nic_name" {
  value = "${azurerm_network_interface.consul-interface.name}"
}

output "cloudbox_resource_group_name" {
  value = "${azurerm_network_interface.consul-interface.resource_group_name}"
}

output "consul_host" {
  value = "${azurerm_public_ip.consul.fqdn}"
}

output "consul_host_id" {
  value = "${azurerm_virtual_machine.consul-host.id}"
}

output "local_module_path" {
  value = "${path.module}"
}

output "cbox_comp_name" {
  value = "${var.cbox_comp_name}"
}
