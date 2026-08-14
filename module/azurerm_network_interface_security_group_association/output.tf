output "network_interface_security_group_association_id" {
    value = {
  for nisg_key , nic in azurerm_network_interface_security_group_association.example : nisg_key => nic.id
}
}