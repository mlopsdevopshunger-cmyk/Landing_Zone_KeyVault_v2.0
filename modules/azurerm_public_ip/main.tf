resource "azurerm_public_ip" "pips" {
for_each = var.pipn
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"

  }