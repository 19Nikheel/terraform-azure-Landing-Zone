output "subnet_id" {
   value = {
    for key,subnet in azurerm_subnet.sn : key=>subnet.id
   }
 }