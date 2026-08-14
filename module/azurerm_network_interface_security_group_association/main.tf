resource "azurerm_network_interface_security_group_association" "example" {
    for_each = var.nic_security_group_association

  network_interface_id      = each.value.network_interface_id
  network_security_group_id = each.value.network_security_group_id
}