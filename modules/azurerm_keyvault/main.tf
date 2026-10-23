resource "azurerm_key_vault" "example" {
  for_each = var.key_vault

  name                       = each.value.key_vault_name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  rbac_authorization_enabled = false
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "List",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "usernamese" {
  for_each = var.key_vault

  name         = each.value.username
  value        = each.value.value_username
  key_vault_id = azurerm_key_vault.example[each.key].id
}
