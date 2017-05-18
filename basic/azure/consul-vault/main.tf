provider "azurerm" {}

data "azurerm_client_config" "current" {}

module "cloudbox-consul" {
  source = "./modules/consul-provisioner"

  cbox_project_name         = "${var.cbox_project_name}"
  cbox_naming_prefix        = "${var.cbox_naming_prefix}"
  cbox_vm_prefix            = "${var.cbox_vm_prefix}"
  cbox_name                 = "${var.cbox_name}"
  cbox_vm_count             = "${var.cbox_vm_count}"
  cbox_env_role             = "${var.cbox_env_role}"
  cbox_resource_group_name  = "${var.cbox_resource_group_name}"
  cbox_virtual_network_name = "${var.cbox_resource_group_name}-VNet"
  cbox_azure_location       = "${var.cbox_azure_location}"
  cbox_storage_vhd_uri      = "${var.cbox_storage_vhd_uri}"
  cbox_vm_role              = "${var.cbox_vm_role}"
  cbox_comp_name            = "${var.cbox_comp_name}"
  cbox_virtual_network_cidr = "${var.cbox_virtual_network_cidr}"
  cbox_vm_size              = "${var.cbox_vm_size}"
  cbadmin_user_username     = "${var.cbadmin_user_username}"
  cbadmin_user_password     = "${var.cbadmin_user_password}"

## Provisioning Section ##
#  prov_consul_user_ids	    = "${var.prov_consul_user_ids}"
#  prov_consul_user_num      = "${var.prov_consul_user_num}"
  
}
