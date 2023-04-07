terraform {
  required_providers {

    random = {
      source = "hashicorp/random"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "random" {

}

provider "azurerm" {
  # Configuration options
  features {

  }
}

# Source code for the Resource Group Creation
resource "azurerm_resource_group" "resource_group" {

  name     = lower("rg-storage-teste")
  location = "westus"
}

resource "random_string" "random" {
  length  = 3
  special = false
  upper   = false
  numeric = true

}

resource "azurerm_storage_account" "storageteste" {
  name                     = "tstatetreinamento${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = "westus"
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "containerteste" {
  name = lower("container-teste")

  storage_account_name = azurerm_storage_account.storageteste.name
  depends_on = [
    azurerm_resource_group.resource_group,
    azurerm_storage_account.storageteste

  ]

}

output "blobstorage-nome" {
  value = azurerm_storage_account.storageteste.name

}

output "blobstorage-chave-primaria" {
  value = azurerm_storage_account.storageteste.primary_access_key
  sensitive = true

}

output "blobstorage-chave-secundaria" {
  value = azurerm_storage_account.storageteste.secondary_access_key
  sensitive = true

}