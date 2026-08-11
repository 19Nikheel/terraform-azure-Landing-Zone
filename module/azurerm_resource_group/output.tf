output "rg_name" {
   value = {
    for key,rg in azurerm_resource_group.rg1 : key=>rg.name
   }
 }