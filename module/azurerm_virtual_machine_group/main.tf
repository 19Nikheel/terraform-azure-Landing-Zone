resource "azurerm_linux_virtual_machine" "example" {
    for_each = var.virtual_machine

  name                = each.value.name

  resource_group_name = each.value.resource_group_name
  location            = each.value.location

  size = each.value.size

  admin_username = each.value.admin_username

  network_interface_ids = [
    each.value.network_interface_id
  ]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = each.value.ssh_public_key
  }

  os_disk {
    caching              = each.value.os_disk_caching
    storage_account_type = each.value.storage_account_type
  }

  source_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
}
