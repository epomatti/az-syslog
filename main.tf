terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.10.0"
    }
  }
}

resource "random_integer" "generated" {
  min = 000
  max = 999
}

locals {
  affix    = random_integer.generated.result
  workload = "${var.project_name}${local.affix}"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}-workload"
  location = var.location
}

module "vnet" {
  source              = "./modules/network/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "vm_syslog" {
  source              = "./modules/vm"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location

  subnet_id       = module.vnet.compute_subnet_id
  size            = var.vm_size
  username        = var.vm_username
  public_key_path = var.vm_public_key_path

  user_data_file_name = "ubuntu_syslog.sh"

  image_publisher = var.vm_image_publisher
  image_offer     = var.vm_image_offer
  image_sku       = var.vm_image_sku
  image_version   = var.vm_image_version
}

module "nsg_syslog" {
  source                          = "./modules/network/nsg-syslog"
  workload                        = local.workload
  resource_group_name             = azurerm_resource_group.default.name
  location                        = azurerm_resource_group.default.location
  compute_subnet_id               = module.vnet.compute_subnet_id
  allowed_source_address_prefixes = var.allowed_source_address_prefixes
  syslog_network_interface_id     = module.vm_syslog.network_interface_id
}
