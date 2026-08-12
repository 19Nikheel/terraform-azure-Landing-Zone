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
        name           = "subnet1"
        address_prefix = ["10.0.1.0/24"]
      },
      subnet2 = {
        name           = "subnet2"
        address_prefix = ["10.0.2.0/24"]
      },
      subnet3 = {
        name           = "subnet3"
        address_prefix = ["10.0.3.0/24"]
      }

    }
  }
}
