
# -----------------------------------------------------------
# Details of the ansible run box which should be used to
# initiate the playbook
# -----------------------------------------------------------
variable "runbox_dependency_hack"                { }
variable "runbox_user"                           { }
variable "runbox_host"                           { }
variable "runbox_user_private_key_pem"           { }

# -----------------------------------------------------------
# Values which can be used to automatically trigger/retrigger
# the running of the ansible playbook
# -----------------------------------------------------------
variable "runtrigger_value"                      { }
variable "runtrigger_manual_value"               { }

# -----------------------------------------------------------
# Variables required to understand how to load the specific
# ansible files which need to be run from the local file
# system where terraform is run from
# -----------------------------------------------------------
variable "localload_target_dir_name"             { }
variable "localload_full_path"                   { }
variable "localload_gen_tpl_path"                { }
variable "localload_gen_tpl_vars"                { type="map" }

variable "localload_target_file_name" {
  default = "main.yml"
}

# -----------------------------------------------------------
# Credentials required when using the Anisble Azure dynamic
# inventory functionality to determine which hosts to run
# the playbook against
# -----------------------------------------------------------
variable "dyninv_azure_resource_group_name"      { }
variable "dyninv_azure_client_id"                { }
variable "dyninv_azure_subscription_id"          { }
variable "dyninv_azure_tenant"                   { }
variable "dyninv_azure_secret"                   { }

# -----------------------------------------------------------
# Additional arguments accepted by the Ansible Azure dynamic
# inventory script
# -----------------------------------------------------------
variable "dyninv_use_private_ip" {}
