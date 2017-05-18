resource "azurerm_resource_group" "test" {
  name     = "ahegazikubecsr4"
  location = "westeurope"
}

resource "azurerm_container_service" "test" {
  name                   = "acctestcontservice1"
  location               = "${azurerm_resource_group.test.location}"
  resource_group_name    = "${azurerm_resource_group.test.name}"
  orchestration_platform = "Kubernetes"

  master_profile {
    count      = 1
    dns_prefix = "testockubecsmaster"
  }

  linux_profile {
    admin_username = "ahegazi"

    ssh_key {
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhVRQ8H7gVU2NutvtgpdcFTYmzi0/omGDY2tm2nkKq35BKNj94MEg7RJ6PJcWWFUz7HtzksnWNqEeYnWl6WJEthQ9Vvhu/x5ZloNEwzvzF4lOSchio+9oahekvGs0HwPYQt7JYRbLRc72WlOEEW1FIxXitfUZFmQ8vQ2QH5XxL+ctsf+Ln8LQ5HHz8/WZwA+oCOs/j57UOBd+9rwhLqjjCrp0iLLycYeoqbBVeJzi/o+xMLnrIlnfOYMyKJSMv7jk6xbGAsjV19BAOmdp8+x+APVnYpNJ/KT4VJU+BfDmno7JwdPSmqx5Ty01OSQOYr6QirTHc3+7OQZMOkh/hQCq/ ahegazi@abdel-oc"
    }
  }

  agent_pool_profile {
    name       = "default"
    count      = 1
    dns_prefix = "testockubecsagent"
    vm_size    = "Standard_A0"
  }

  service_principal {
    client_id     = "${var.clinet_id}"
    client_secret = "${var.client_secret}" 
  }

  diagnostics_profile {
    enabled = false
  }

  tags {
    Environment = "dev"
  }
}
