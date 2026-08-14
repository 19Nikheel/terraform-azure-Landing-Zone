output "network_interface_id" {
    value = {
  for nic_key , nic in azurerm_network_interface.example : nic_key => nic.id
}
}