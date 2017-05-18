# Used to generate additional variables required for ansible, but currently
# only available via terraform
data "template_file" "gen-ansible-vars-from-tf" {
    template = "${var.localload_gen_tpl_path}"
    vars     = "${var.localload_gen_tpl_vars}"
}
resource "null_resource" "run-ansible-playbook" {

    # unfortunately the depends_on value cannot contain interpolations, so we need
    # to resort to some other jiggery pokery to try and force this dependency ...
    # see
    # depends_on = ["${var.ansible_install_runner_modulename}"]

    # Initiate this provisioner whenever one of these triggers
    # changes
    triggers {
        trigger-value           = "${var.runtrigger_value}"
        trigger-manual-value    = "${var.runtrigger_manual_value}"
    }

    # Connect to the ansible runbox
    connection {
        host                    = "${var.runbox_host}"
        type                    = "ssh"
        user                    = "${var.runbox_user}"
        agent                   = false
        private_key             = "${var.runbox_user_private_key_pem}"
    }

    # Hack to get around the fact that depends_on cannot contain interpolations
    provisioner "remote-exec" {
        inline = [
              "echo '---- Setting up to run playbook ----'",
              " echo '${var.runbox_dependency_hack}' "
        ]
    }

    # Copies the specific directory and all its contents (from the local system
    # running terraform) to the expected location where all the main Ansible
    # playbooks are run from.
    # This resource should be dependant on the module which is responisble for
    # installing ansible however
    provisioner "file" {
        source       = "${var.localload_full_path}"
        destination  = "~/provisioning/ansible/comps"
    }

    provisioner "remote-exec" {
        inline = [
        # -----------------------------------------------------------
        #    Now kick of an initial Ansible provisioning run to
        #    install any additionaly software on any boxes managed
        #    by this module.
        #
        #    If you want to run this manually, you will need to
        #    A) SSH as the cbadmin user onto the bastion box
        #    B) Ensure the terraform-gen-vars.yml file still has
        #       correct content (this is generated by terraform)
        #    C) Setup the appropriate azure credentials as
        #       environment variables (required for dynamic inventory
        #       to work) as well as any others required
        #       for Ansible e.g.
        #         export ANSIBLE_HOST_KEY_CHECKING=False
        #         export AZURE_CLIENT_ID=xxxx
        #         export AZURE_SECRET=xxxx
        #         export AZURE_TENANT=xxxx
        #         export AZURE_SUBSCRIPTION_ID=xxxx
        #
        #         ansible-playbook -i ~/provisioning/ansible/bin/azure_rm.py ~/provisioning/ansible/comps/<<compdir>>/main.yml
        #
        # -----------------------------------------------------------
              "echo '---- Kick off configuration management for any boxes which may need it ----'",

            # We need to generate some vars on the fly based on terraform
            "rm -f ~/provisioning/ansible/comps/${var.localload_target_dir_name}/tf-vars.yml",
            "echo '${data.template_file.gen-ansible-vars-from-tf.rendered}' > ~/provisioning/ansible/comps/${var.localload_target_dir_name}/tf-vars.yml",

            # Copy the dynamic inventory script into the hosts directory so that we can take advantage of Ansible's ability to combine
            # static and dynamic inventory files
            "mkdir --parents ~/provisioning/ansible/comps/${var.localload_target_dir_name}/hosts",
            "cp ~/provisioning/ansible/bin/azure_rm.py ~/provisioning/ansible/comps/${var.localload_target_dir_name}/hosts",

            # Run the actual playbook
            "ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_CONFIG=~/provisioning/ansible/comps/${var.localload_target_dir_name}/ansible.cfg AZURE_SECRET=${var.dyninv_azure_secret} AZURE_CLIENT_ID=${var.dyninv_azure_client_id} AZURE_TENANT=${var.dyninv_azure_tenant} AZURE_SUBSCRIPTION_ID=${var.dyninv_azure_subscription_id} AZURE_RESOURCE_GROUPS=${var.dyninv_azure_resource_group_name} AZURE_PREFER_PRIVATE_IP=${var.dyninv_use_private_ip} ansible-playbook -i ~/provisioning/ansible/comps/${var.localload_target_dir_name}/hosts ~/provisioning/ansible/comps/${var.localload_target_dir_name}/${var.localload_target_file_name}",
        ]
    }
}
