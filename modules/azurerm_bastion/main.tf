resource "azurerm_bastion_host" "example" {
    for_each = var.bsnc
  name                = each.value.bsn_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.example_bsnsubnet[each.key].id
    public_ip_address_id = data.azurerm_public_ip.example[each.key].id
  }
}
