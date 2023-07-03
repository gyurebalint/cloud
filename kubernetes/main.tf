provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.78.0"
    }
  }
}

resource "azurerm_resource_group" "kube_resource" {
  name     = "example-kube"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "kubernetes" {
  name                = "system"
  location            = azurerm_resource_group.kube_resource.location
  resource_group_name = azurerm_resource_group.kube_resource.name
  dns_prefix          = "radgaul"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.kubernetes.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.kubernetes.kube_config_raw
  sensitive = true
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.kubernetes.id
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.kubernetes.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.kubernetes.node_resource_group
}