terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  cloud {
    organization = "AnkitPipalia"

    workspaces {
      name = "Task-backend"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "a9ecd4c5-920a-4feb-ae4a-c39ea86eb6fc"
  tenant_id       = "9e150f1d-92d8-47f9-bf6f-b44bc4b2fa6c"
  client_id       = "8b616e74-e222-492d-b78a-f50be60faf6c"
  client_secret   = "OtX8Q~hnrWp2FPNiTC3eBJ~A0W7fjS64oKtbncvC"
}

resource "azurerm_resource_group" "kube-rg" {
  name     = "Kubernetes"
  location = "Central India"

  tags = {
    Task  = "Ankit"
    Ankit = "Resource Group"
  }
}

resource "azurerm_virtual_network" "kube_vnet" {
  name                = "kubernetes-vnet"
  location            = azurerm_resource_group.kube-rg.location
  resource_group_name = azurerm_resource_group.kube-rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Task  = "Ankit"
    Ankit = "Virtual Network"
  }
}

resource "azurerm_subnet" "vm_sub" {
  name                 = "ankit_vmss_sub"
  resource_group_name  = azurerm_resource_group.kube-rg.name
  virtual_network_name = azurerm_virtual_network.kube_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Master-node
resource "azurerm_network_interface" "master-nic" {
  name                = "master-nic"
  location            = azurerm_resource_group.kube-rg.location
  resource_group_name = azurerm_resource_group.kube-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.master-pubip.id
  }

  depends_on = [azurerm_public_ip.master-pubip]
}

resource "azurerm_public_ip" "master-pubip" {
  name                = "Master-pubip"
  resource_group_name = azurerm_resource_group.kube-rg.name
  location            = azurerm_resource_group.kube-rg.location
  allocation_method   = "Static"

  tags = {
    Task  = "Ankit"
    Ankit = "Public IP"
  }
}

resource "azurerm_linux_virtual_machine" "master_vm" {
  name                            = "k8s-master"
  resource_group_name             = azurerm_resource_group.kube-rg.name
  location                        = azurerm_resource_group.kube-rg.location
  size                            = "Standard_B2s"
  admin_username                  = "azure"
  disable_password_authentication = false
  admin_password                  = "Ankitpipalia@2002"
  network_interface_ids = [
    azurerm_network_interface.master-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-lunar"
    sku       = "minimal-23_04-gen2"
    version   = "latest"
  }
}

# WorkerNode 1
resource "azurerm_network_interface" "worker1-nic" {
  name                = "worker1-nic"
  location            = azurerm_resource_group.kube-rg.location
  resource_group_name = azurerm_resource_group.kube-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.worker1-pubip.id
  }

  depends_on = [azurerm_public_ip.worker1-pubip , azurerm_network_interface.master-nic]
}

resource "azurerm_public_ip" "worker1-pubip" {
  name                = "Worker1-pubip"
  resource_group_name = azurerm_resource_group.kube-rg.name
  location            = azurerm_resource_group.kube-rg.location
  allocation_method   = "Static"

  tags = {
    Task  = "Ankit"
    Ankit = "Public IP"
  }
}

resource "azurerm_linux_virtual_machine" "worker1_vm" {
  name                            = "k8s-worker1"
  resource_group_name             = azurerm_resource_group.kube-rg.name
  location                        = azurerm_resource_group.kube-rg.location
  size                            = "Standard_B1ms"
  admin_username                  = "azure"
  disable_password_authentication = false
  admin_password                  = "Ankitpipalia@2002"
  network_interface_ids = [
    azurerm_network_interface.worker1-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-lunar"
    sku       = "minimal-23_04-gen2"
    version   = "latest"
  }
}

# WorkerNode 2
resource "azurerm_network_interface" "worker2-nic" {
  name                = "worker2-nic"
  location            = azurerm_resource_group.kube-rg.location
  resource_group_name = azurerm_resource_group.kube-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.worker2-pubip.id
  }

  depends_on = [azurerm_public_ip.worker2-pubip , azurerm_network_interface.worker1-nic , azurerm_network_interface.master-nic ]
}

resource "azurerm_public_ip" "worker2-pubip" {
  name                = "Worker2-pubip"
  resource_group_name = azurerm_resource_group.kube-rg.name
  location            = azurerm_resource_group.kube-rg.location
  allocation_method   = "Static"

  tags = {
    Task  = "Ankit"
    Ankit = "Public IP"
  }
}

resource "azurerm_linux_virtual_machine" "worker2_vm" {
  name                            = "k8s-worker2"
  resource_group_name             = azurerm_resource_group.kube-rg.name
  location                        = azurerm_resource_group.kube-rg.location
  size                            = "Standard_B1ms"
  admin_username                  = "azure"
  disable_password_authentication = false
  admin_password                  = "Ankitpipalia@2002"
  network_interface_ids = [
    azurerm_network_interface.worker2-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-minimal-lunar"
    sku       = "minimal-23_04-gen2"
    version   = "latest"
  }
}