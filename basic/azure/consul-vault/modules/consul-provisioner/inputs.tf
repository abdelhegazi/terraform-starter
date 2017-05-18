# -----------------------------------------------------------
# -----------------------------------------------------------
variable "cbox_project_name" {}

variable "cbox_naming_prefix" {}
variable "cbox_vm_prefix" {}
variable "cbox_name" {}
variable "cbox_vm_count" {}
variable "cbox_env_role" {}
variable "cbox_resource_group_name" {}
variable "cbox_virtual_network_name" {}
variable "cbox_storage_vhd_uri" {}
variable "cbox_azure_location" {}

#variable "cbox_subnet_dmz_id" {}
variable "cbox_virtual_network_cidr" {}

variable "cbox_vm_size" {}
variable "cbox_comp_name" {}
variable "cbox_vm_role" {}
variable "cbadmin_user_username" {}
variable "cbadmin_user_password" {}
##variable "cbadmin_user_public_key_openssh" {}
##variable "cbadmin_user_privkey_path" {}
##variable "cbadmin_user_private_key_pem" {}


# ---------------------
# Provisioning Consul 
# ---------------------

#variable "prov_trigger_ansible_manual_val" {}
variable "prov_make_consul_ansiblerunner" {
  default = "1"
}
#variable "prov_runtrigger_manual_value" {
#  default = "consul"
#}

#variable "prov_consul_user_ids" {}

variable "prov_consul_user_num" {
  default = "1"
}
variable "consul_user_name" {
  default = "ccadmin"
}


#######################################
#variable "prov_azure_client_id" {}
#variable "prov_azure_subscription_id" {}
#variable "prov_azure_tenant" {}
#variable "prov_azure_secret" {}
#variable "prov_use_private_ip" {}
