output "network_security_group_ids" {
    value = {
  for nsg_key , nsg in azurerm_network_security_group.example : nsg_key => nsg.id
}
}