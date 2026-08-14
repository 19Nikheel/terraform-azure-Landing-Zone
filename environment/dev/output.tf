output "public_ips" {
  value = module.azurerm_public_ip.public_ip_addresses
}