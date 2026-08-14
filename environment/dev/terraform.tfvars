rgs = {
  rg1 = {
    name     = "rg1"
    location = "eastasia"
  }
}

storage_accounts = {
  sa1 = {
    name                     = "storageaccountdev1910"
    resource_group_name      = "rg1"
    location                 = "eastasia"
    account_tier             = "Standard"
    account_replication_type = "LRS"

    containers = {
      con1 = {
        name                  = "tfstate"
        container_access_type = "private"
      }
    }
  }
}


vnets = {
  vnet1 = {
    name                = "vnet1"
    resource_group_name = "rg1"
    location            = "eastasia"
    address_space       = ["10.0.0.0/16"]
  }
}


subnets = {
  vn = {
    vnet_name           = "vnet1"
    resource_group_name = "rg1"

    subnet = {
      subnet1 = {
        name           = "frontend"
        address_prefix = ["10.0.1.0/24"]
      },
      subnet2 = {
        name           = "backend"
        address_prefix = ["10.0.2.0/24"]
      },
      subnet3 = {
        name           = "db"
        address_prefix = ["10.0.3.0/24"]
      }

    }
  }
}

public_ips = {
  gen = {
    resource_group_name = "rg1"
    location            = "eastasia"

    pip = {
      pip1 = {
        name              = "pip1"
        allocation_method = "Static"
      }
    }
  }

}


nics = {
  nic1 = {
    name                = "nic1"
    location            = "eastasia"
    resource_group_name = "rg1"

    ip_configuration = {
      ip1 = {
        name                          = "ipconfig1"
        subnet_key                    = "vn-subnet1"
        public_ip_key                 = "gen-pip1"
        private_ip_address_allocation = "Dynamic"
      }
    }
  }
}

virtual_machine = {
  vm1 = {
    name                 = "vm1"
    resource_group_name  = "rg1"
    location             = "eastasia"
    size                 = "Standard_B2ats_v2"
    admin_username       = "adminuser"
    network_interface_id = "nic1-ip1"
    os_disk_caching      = "ReadWrite"
    storage_account_type = "Standard_LRS"
    publisher            = "Canonical"
    offer                = "0001-com-ubuntu-server-jammy"
    sku                  = "22_04-lts"
    version              = "latest"
  }
}


network_security_group = {
  nsg1 = {
    name                = "nsg1"
    resource_group_name = "rg1"
    location            = "eastasia"

    security_rule = {
      sr1 = {
        security_rule_name                       = "AllowSSH"
        security_rule_priority                   = 100
        security_rule_direction                  = "Inbound"
        security_rule_access                     = "Allow"
        security_rule_protocol                   = "Tcp"
        security_rule_source_port_range          = "*"
        security_rule_destination_port_range     = "22"
        security_rule_source_address_prefix      = "*"
        security_rule_destination_address_prefix = "*"
      }
    }
  }
}

network_interface_security_group_association = {
  nisg1 = {
    network_interface_id      = "nic1-ip1"
    network_security_group_id = "nsg1-sr1"
  }
}