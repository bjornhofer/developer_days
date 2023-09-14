terraform {
    backend "azurerm" {
    resource_group_name  = "AUVA"
    storage_account_name = "auvastatefile01"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
    name = var.resource_group_name
}

locals {
    basename = "${var.prefix}${var.basename}${var.suffix}"
}

resource "azurerm_container_registry" "acr" {
  name                = local.basename
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location != null ? var.location : data.azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.basename
  location            = var.location != null ? var.location : data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "catupload"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

// Allow Kubernetes access to ACR
resource "azurerm_role_assignment" "aks_acr_access" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
