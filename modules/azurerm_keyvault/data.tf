data "azurerm_client_config" "current" {}  
#   Attribute           Purpose  
#  tenant_id            The Microsoft Entra ID (Azure AD) tenant ID
#  subscription_id      The Azure subscription ID
#  client_id            The application or client ID used for authentication
#  object_id            The object ID of the authenticated identity, when available

# data "azurerm_key_vault" "example" {
#     for_each = var.key_vault
#   name                = each.value.key_vault_name
#   resource_group_name = each.value.resource_group_name
# }