## -----------------------------------------------------------
variable "cbox_project_name" {
  default = "consul-proj"
}

variable "cbox_naming_prefix" {
  default = "cbox-consul"
}

variable "cbox_vm_prefix" {
  default = "cbox-consul-vm"
}

variable "cbox_name" {
  default = "cbabdelbox1"
}

variable "cbox_vm_count" {
  default = "1"
}

variable "cbox_env_role" {
  default = "consul"
}

variable "cbox_vm_role" {
  default = "consul-backend"
}

variable "cbox_resource_group_name" {
  default = "consulcboxtest1"
}

variable "cbox_virtual_network_name" {
  default = "cbox_comp_consul"
}

variable "cbox_storage_vhd_uri" {
  default = "cbox-consul-comp"
}

variable "cbox_azure_location" {
  default = "ukwest"
}

#variable "cbox_subnet_dmz_id" {}

variable "cbox_virtual_network_cidr" {
  default = "10.0.0.0/16"
}

variable "cbox_vm_size" {
  default = "Standard_A1"
}

variable "cbox_comp_name" {
  default = "consul"
}

variable "cbadmin_user_username" {
  default = "cbadmin"
}

variable "cbadmin_user_password" {
  default = "test1234$"
}
##variable "cbadmin_user_public_key_openssh" {}
##variable "cbadmin_user_privkey_path" {}
##variable "cbadmin_user_private_key_pem" {}


# ------------------------
# Consul Provisioning  
# ------------------------
#variable "prov_trigger_ansible_manual_val" {}
#
#variable "prov_make_bastion_ansiblerunner" {}
#
#variable "prov_azure_client_id" {}
#variable "prov_azure_subscription_id" {}
#variable "prov_azure_tenant" {}
#variable "prov_azure_secret" {}
#
#variable "prov_use_private_ip" {}
#

#variable "prov_consul_user_ids" {}
#variable "prov_consul_user_num" {}


#variable "prov_runtrigger_manual_value"          {}

