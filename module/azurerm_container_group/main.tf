resource "azurerm_storage_container" "example" {
    for_each=var.con
  name                  = each.value.name
  storage_account_id    = each.value.storage_account_id
  container_access_type =   each.value.container_access_type
}