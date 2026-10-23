data "azurerm_subnet" "example_nic" {
    for_each = var.vmsc
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_key_vault" "kv" {
  name                = "tijorikeyvault"
  resource_group_name = "rg-axion-system"
}

data "azurerm_key_vault_secret" "kvu" {
  name         = "username"
  key_vault_id = data.azurerm_key_vault.kv.id
} 