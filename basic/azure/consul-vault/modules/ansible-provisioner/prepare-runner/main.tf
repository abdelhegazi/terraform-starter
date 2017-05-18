# ------------------------------------------------------------
#                   PROVISIONING BOX BOOTSTRAPPING
#
#   Ensure that the provisioning box itself has the necessary
#   packages (Ansible and any of its dependencies) installed. 
#
# ------------------------------------------------------------
resource "null_resource" "install-ansible-on-consulbox" {

    count = "${var.runbox_perform_prep == "true" ? 1 : 0}"
    # If the provisioning box changes or is regenerated, we need
    # to resetup
    triggers {
        provisioning-instance-id = "${var.runbox_host_id}"
    }

    # Connection details to getting onto the provisioning box, which
    # will then be used to do further provisioning on the target hosts
    # (This will require the target hosts to be able to be connected
    #  to by the user specified here)
    connection {
        host         = "${var.runbox_host}"
        type         = "ssh"
        user         = "${var.runbox_user}"
        agent        = false
    #    private_key  = "${var.runbox_private_key_pem}"
        password     = "${var.runbox_password}"
    }    

    provisioner "remote-exec" {   
        inline = [ 
        # -----------------------------------------------------------
        #    Bootstrapping of Ansible itself onto the designated
        #    provisioning box, and ensuring the key to provision
        #    is also present (TODO this should not be cbadmin)
        # -----------------------------------------------------------
              "echo '---- Bootstrapping ansible onto the provisioning box ----'",
              "sudo yum -y clean all",
              "sudo yum -y install epel-release", 
              "sudo yum -y upgrade", 
              "sudo yum -y install gcc libffi-devel python-devel openssl-devel python-pip vim git",
              "sudo pip install --upgrade pip",
              "sudo pip install ansible==2.2.0.0",
              "sudo pip install azure==2.0.0rc5",
              "sudo pip install msrestazure",
              "sudo pip install --upgrade setuptools",
              "sudo pip install passlib",
              "mkdir ~/.azure",
              #"echo '${var.runbox_private_key_pem}' > ~/.ssh/id_rsa",
              "sudo chmod 600 ~/.ssh/id_rsa",
              "mkdir -p ~/provisioning/ansible/bin",
              "mkdir -p ~/provisioning/ansible/comps",
        ]  
    }

    # Copies the core ansible folder to the known locaation~/provisioning/cloudbox
    provisioner "file" {
        source       = "${path.module}/ansible/"
        destination  = "~/provisioning/ansible/bin"
    } 

    # Ensures python module can be executed as part of Ansible dynammic
    # inventory
    provisioner "remote-exec" {   
        inline = [ 
              "sudo chmod +x ~/provisioning/ansible/bin/azure_rm.py",
        ]  
    }    
}

data "external" "dependency_hack" {
  depends_on = ["null_resource.install-ansible-on-consulbox"]
  program = ["echo", "{ \"msg\": \"hack to get arround terraform depends_on short coming\" }"]
}

output "runbox_dependency_hack" {
  value = "${data.external.dependency_hack.result["msg"]}"
}
