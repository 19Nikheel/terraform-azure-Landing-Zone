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
        virtual_network_name = vnet.vnet_name
        resource_group_name  = vnet.resource_group_name
        name                 = subnet.name
        address_prefixes     = subnet.address_prefix
      }
    }
  ]...)
}

module "azurerm_public_ip" {
  depends_on = [module.azurerm_resource_group]

  source = "../../module/azurerm_public_ip"
  public_ips = merge([
    for pub_key, pub in var.public_ips : {
      for pip_key, pip in pub.pip : "${pub_key}-${pip_key}" => {
        name                = pip.name
        resource_group_name = pub.resource_group_name
        location            = pub.location
        allocation_method   = pip.allocation_method
      }
    }
  ]...)
}


module "azurerm_nic" {
  depends_on = [module.azurerm_subnet, module.azurerm_public_ip]

  source = "../../module/azurerm_nic_group"
  nics = merge([
    for nic_key, nic in var.nics : {
      for ip_config_key, ip_config in nic.ip_configuration : "${nic_key}-${ip_config_key}" => {
        name                          = nic.name
        location                      = nic.location
        resource_group_name           = nic.resource_group_name
        ip_configuration_name         = ip_config.name
        subnet_id                     = module.azurerm_subnet.subnet_id[ip_config.subnet_key]
        private_ip_address_allocation = ip_config.private_ip_address_allocation
        public_ip_address_id          = module.azurerm_public_ip.public_ip_ids[ip_config.public_ip_key]
      }
    }
  ]...)
}

module "azurerm_virtual_machine" {
  depends_on = [module.azurerm_nic]

  source = "../../module/azurerm_virtual_machine_group"
  virtual_machine = {
    for vm_key, vm in var.virtual_machine : vm_key => {

      name                 = vm.name
      location             = vm.location
      resource_group_name  = vm.resource_group_name
      network_interface_id = module.azurerm_nic.network_interface_id[vm.network_interface_id]
      size                 = vm.size
      admin_username       = vm.admin_username
//      ssh_public_key       = file("~/.ssh/id_rsa.pub") // comment this varible in variable.tf  for local
      ssh_public_key       = var.ssh_public_key // remote
      os_disk_caching      = vm.os_disk_caching
      storage_account_type = vm.storage_account_type
      publisher            = vm.publisher
      offer                = vm.offer
      sku                  = vm.sku
      version              = vm.version
    }

  }
}

module "azurerm_network_security_group" {
  depends_on = [module.azurerm_resource_group]

  source = "../../module/azurerm_network_security_group"
  network_security_group = merge([
    for nsg_key, nsg in var.network_security_group : {
      for rule_key, rule in nsg.security_rule : "${nsg_key}-${rule_key}" => {
        name                                     = nsg.name
        location                                 = nsg.location
        resource_group_name                      = nsg.resource_group_name
        security_rule_name                       = rule.security_rule_name
        security_rule_priority                   = rule.security_rule_priority
        security_rule_direction                  = rule.security_rule_direction
        security_rule_access                     = rule.security_rule_access
        security_rule_protocol                   = rule.security_rule_protocol
        security_rule_source_port_range          = rule.security_rule_source_port_range
        security_rule_destination_port_range     = rule.security_rule_destination_port_range
        security_rule_source_address_prefix      = rule.security_rule_source_address_prefix
        security_rule_destination_address_prefix = rule.security_rule_destination_address_prefix
      }
    }
  ]...)
}

module "azurerm_network_interface_security_group_association" {
  depends_on = [module.azurerm_nic, module.azurerm_network_security_group]

  source = "../../module/azurerm_network_interface_security_group_association"
  nic_security_group_association = {
    for nisg_key, nisg in var.network_interface_security_group_association : nisg_key => {
      network_interface_id      = module.azurerm_nic.network_interface_id[nisg.network_interface_id]
      network_security_group_id = module.azurerm_network_security_group.network_security_group_ids[nisg.network_security_group_id]
    }
  }
}


