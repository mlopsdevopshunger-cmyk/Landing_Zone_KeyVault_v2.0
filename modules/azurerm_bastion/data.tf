data "azurerm_subnet" "example_bsnsubnet" {
for_each=var.bsnc

  name                 = each.value.bastion_subname 
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "example" {
for_each=var.bsnc
  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}