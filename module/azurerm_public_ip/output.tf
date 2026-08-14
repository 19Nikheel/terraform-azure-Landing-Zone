output "public_ip_ids" {
  value = {
    for pub_key, pub in azurerm_public_ip.example : pub_key => pub.id
  }
}

output "public_ip_addresses" {
  value = {
    for key, pip in azurerm_public_ip.example :
    key => pip.ip_address
  }
}

