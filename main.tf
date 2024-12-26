# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "random_string" "azurerm_kubernetes_cluster_node_pool" {
  length  = 6
  special = false
  numeric = false
  lower   = true
  upper   = false
}

resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = random_pet.azurerm_kubernetes_cluster_name.id
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name               = "systempool"
    vm_size            = "Standard_D2_v2"
    type               = "VirtualMachineScaleSets"
    min_count          = 1
    max_count          = 3
    vnet_subnet_id     = azurerm_subnet.subnet.id
    zones              = [1, 2, 3]  # Enable availability zones
    enable_auto_scaling = true
    
    # Add tags for better resource management
    tags = {
      Environment = "Production"
      Purpose     = "System"
    }
  }

  windows_profile {
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"  # Required for availability zones
  }

  auto_scaler_profile {
    balance_similar_node_groups = true
    expander                   = "random"
    scale_down_delay_after_add = "10m"
    scale_down_unneeded        = "10m"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "win" {
  name                  = random_string.azurerm_kubernetes_cluster_node_pool.result
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size              = "Standard_D4s_v3"
  enable_auto_scaling = true
  min_count            = 1
  max_count            = 3
  os_type              = "Windows"
  zones                = [1, 2, 3]  # Enable availability zones for Windows nodes
  
  # Add tags for better resource management
  tags = {
    Environment = "Production"
    Purpose     = "Windows"
  }
}