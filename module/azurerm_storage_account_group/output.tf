# data "azurerm_storage_account" "main" {
#   for_each = var.storage_accounts

#   name                = each.value.name
#   resource_group_name = each.value.resource_group_name
# }

output "storage_account_ids" {
  value = { for k, v in azurerm_storage_account.example : k => v.id }
}

output "storage_account_name" {
  value = { for k, v in azurerm_storage_account.example : k => v.name }
}