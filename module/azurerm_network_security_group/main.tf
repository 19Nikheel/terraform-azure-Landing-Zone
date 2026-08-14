resource "azurerm_network_security_group" "example" {
    for_each = var.network_security_group

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = each.value.security_rule_name
    priority                   = each.value.security_rule_priority
    direction                  = each.value.security_rule_direction
    access                     = each.value.security_rule_access
    protocol                   = each.value.security_rule_protocol
    source_port_range          = each.value.security_rule_source_port_range
    destination_port_range     = each.value.security_rule_destination_port_range
    source_address_prefix      = each.value.security_rule_source_address_prefix
    destination_address_prefix = each.value.security_rule_destination_address_prefix
  }
}


