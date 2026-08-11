module "azurerm_resource_group" {
  source = "../../module/azurerm_resource_group"
  rgs    = var.rgs
}

module "azurerm_storage_account" {

  depends_on       = [module.azurerm_resource_group]
  source           = "../../module/azurerm_storage_account_group"
  storage_accounts = var.storage_accounts
}

module "azurerm_storage_container" {
  depends_on = [module.azurerm_storage_account]
  source     = "../../module/azurerm_container_group"

  con = merge([
    for sa_key, sa in var.storage_accounts : {
      for container_key, container in sa.containers :
      "${sa_key}-${container_key}" => {
        name                  = container.name
        storage_account_id    = module.azurerm_storage_account.storage_account_ids[sa_key]
        container_access_type = container.container_access_type
      }
    }
  ]...)
}


module "azurerm_vnet" {
  depends_on = [module.azurerm_resource_group]

  source = "../../module/azurerm_vnet_group"
  vnets  = var.vnets
}


module "azurerm_subnet" {
  depends_on = [module.azurerm_vnet]

  source = "../../module/azurerm_subnet_group"
  subnets = merge([
    for sub_key, vnet in var.subnets : {
      for subnet_key, subnet in vnet.subnet : "${sub_key}-${subnet_key}" => {
        virtual_network_name           = vnet.vnet_name
        resource_group_name = vnet.resource_group_name
        name                = subnet.name
        address_prefixes      = subnet.address_prefix
      }
    }
  ]...)
}




