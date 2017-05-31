resource "azurerm_resource_group" "test" {
  name     = "ahegazikubecsr4"
  location = "westeurope"
}

resource "azurerm_container_service" "test" {
  name                   = "acctestcontservice1"
  location               = "${azurerm_resource_group.test.location}"
  resource_group_name    = "${azurerm_resource_group.test.name}"
  orchestration_platform = "Kubernetes"

# Azure APIs currently only suuports 1,3 or 5  as number of master nodes
  master_profile {
    count      = 1
    dns_prefix = "testockubecsmaster"
  }

  linux_profile {
    admin_username = "ahegazi"

    ssh_key {
      key_data = "${var.ssh-key}"
    }
  }

  agent_pool_profile {
    name       = "default"
    count      = 2
    dns_prefix = "testockubecsagent"
    vm_size    = "Standard_A0"
  }

# This is a bug with terraform (9.3) it doesn't pickup these secrets from defined environment variables
# you have to pass them 
  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}" 
  }

  diagnostics_profile {
    enabled = false
  }

  tags {
    Environment = "dev"
  }
}
