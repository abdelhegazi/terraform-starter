# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#            Prep/install of Ansible onto box (consul in this case)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
module "cloudbox-provisioner-prepare-runner" {
  source = "../ansible-provisioner/prepare-runner"

  #cbox_project_name      = "${var.cbox_project_name}"
  #cbox_naming_prefix     = "${var.cbox_naming_prefix}"
  #cbox_name              = "${var.cbox_name}"

  # Details of box into which Ansible etc should be installed
  runbox_perform_prep = "${var.prov_make_consul_ansiblerunner}"
  runbox_host         = "${azurerm_public_ip.consul.fqdn}"
  runbox_host_id      = "${azurerm_virtual_machine.consul-host.id}"
  runbox_user         = "${var.cbadmin_user_username}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#            prep required for provisioning module below
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

data "null_data_source" "tfgen-vars" {
  inputs = {
    consul_fqdn               = "${azurerm_public_ip.consul.fqdn}"
    consul_admin_password     = "${random_id.consul-admin-password.b64}"
    cbox_virtual_network_cidr = "${var.cbox_virtual_network_cidr}"

    # Terraform can't handle lists in templates. Meh.
    #consul_user_ids       = "${join(",", var.prov_consul_user_ids)}"
    #consul_users     = "${ var.prov_consul_user_ids }"
    consul_users     = "${var.consul_user_name}"
    consul_passwords = "${ join(",",data.template_file.consuluser-initial-password.*.rendered) }"
  }
}

# Consul service admin password
resource "random_id" "consul-admin-password" {
  byte_length = 8
}

# Note: this will generate new passwords each time terraform is run.
#       Although you generally wouldn't want this, it helps from a security
#       perspective to ensure latest password is not held in state. If the
#       user doesn't note it down first time round its gone!
#       This is until we can do a proper playbook for this.
data "template_file" "consuluser-initial-password" {
#data "template_file" "vpnuser-initial-password" {
  count    = "${var.prov_consul_user_num}"
  template = "${uuid()}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#            Initiation of Ansible against the boxes in the secure access component
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#module "cloudbox-provisioner-run-playbook-4-secacc" {
#  source = "../ansible-provisioner/run-playbook"
#
#  # Details of box which should be used to run Ansible from
#  runbox_dependency_hack      = "${module.cloudbox-provisioner-prepare-runner.runbox_dependency_hack}"
#  runbox_user                 = "${var.cbadmin_user_username}"
#  runbox_user_private_key_pem = "${var.cbadmin_user_private_key_pem}"
#  runbox_host                 = "${module.cloudbox-provisioner-prepare-runner.runbox_hostname}"
#
#  # Values which can be used to automatically trigger/retrigger the running of the ansible playbook
#  runtrigger_manual_value = "${var.prov_trigger_ansible_manual_val}"
#  runtrigger_value        = "${azurerm_virtual_machine.bastion.id}"
#
#  # Details how to load the specific ansible files from the local file system where terraform is run from
#  localload_full_path       = "${path.module}/provisioning/secure-access"
#  localload_target_dir_name = "secure-access"
#  localload_gen_tpl_path    = "${file("${path.module}/provisioning/templates/tf-vars.yml.tpl")}"
#  localload_gen_tpl_vars    = "${data.null_data_source.tfgen-vars.inputs}"
#
#  # Azure credentials required when using the Ansible Azure dynamic inventory functionality to 
#  # determine which hosts to run the playbook against
#  dyninv_azure_resource_group_name = "${var.cbox_resource_group_name}"
#
#  dyninv_azure_client_id       = "${var.prov_azure_client_id}"
#  dyninv_azure_subscription_id = "${var.prov_azure_subscription_id}"
#  dyninv_azure_tenant          = "${var.prov_azure_tenant}"
#  dyninv_azure_secret          = "${var.prov_azure_secret}"
#  dyninv_use_private_ip        = "${var.prov_use_private_ip}"
#}
