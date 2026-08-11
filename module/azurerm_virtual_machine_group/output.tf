output "subnet_id" {
   value = {
    for key,subnet in azurerm_subnet.this : key=>subnet_id
   }
 }