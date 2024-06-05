# Create an Azure Resource Group
resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"    # Name of the resource group, using a variable prefix
  location = var.location          # Location of the resource group, using a variable
}

# Create an Azure Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"    # Name of the virtual network, using a variable prefix
  address_space       = ["10.0.0.0/16"]            # Address space for the virtual network
  location            = azurerm_resource_group.example.location    # Location from the resource group
  resource_group_name = azurerm_resource_group.example.name        # Resource group name from the resource group
}

# Create a Subnet within the Virtual Network
resource "azurerm_subnet" "internal" {
  name                 = "internal"                # Name of the subnet
  resource_group_name  = azurerm_resource_group.example.name        # Resource group name from the resource group
  virtual_network_name = azurerm_virtual_network.main.name          # Virtual network name from the virtual network
  address_prefixes     = ["10.0.2.0/24"]           # Address prefix for the subnet
}

# Create a Network Interface
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"        # Name of the network interface, using a variable prefix
  location            = azurerm_resource_group.example.location    # Location from the resource group
  resource_group_name = azurerm_resource_group.example.name        # Resource group name from the resource group

  # IP Configuration for the Network Interface
  ip_configuration {
    name                          = "testconfiguration1"           # Name of the IP configuration
    subnet_id                     = azurerm_subnet.internal.id     # Subnet ID from the subnet
    private_ip_address_allocation = "Dynamic"                      # Allocation method for the private IP address
  }
}

# Create a Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"        # Name of the virtual machine, using a variable prefix
  location              = azurerm_resource_group.example.location    # Location from the resource group
  resource_group_name   = azurerm_resource_group.example.name        # Resource group name from the resource group
  network_interface_ids = [azurerm_network_interface.main.id]        # Network interface ID from the network interface
  vm_size               = "Standard_DS1_v2"         # Size of the virtual machine

  # Uncomment to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  # Storage Image Reference for the VM
  storage_image_reference {
    publisher = "Canonical"        # Publisher of the image
    offer     = "0001-com-ubuntu-server-jammy"    # Offer of the image
    sku       = "22_04-lts"        # SKU of the image
    version   = "latest"           # Version of the image
  }

  # OS Disk Configuration for the VM
  storage_os_disk {
    name              = "myosdisk1"                # Name of the OS disk
    caching           = "ReadWrite"                # Caching option for the OS disk
    create_option     = "FromImage"                # Creation option for the OS disk
    managed_disk_type = "Standard_LRS"             # Type of managed disk
  }

  # OS Profile Configuration for the VM
  os_profile {
    computer_name  = "hostname"                    # Hostname of the VM
    admin_username = "testadmin"                   # Admin username
    admin_password = "Password1234!"               # Admin password (should be stored securely in production)
  }

  # Linux OS Profile Configuration
  os_profile_linux_config {
    disable_password_authentication = false        # Allow password authentication
  }

  # Tags to categorize the VM
  tags = {
    environment = "staging"                        # Tag to indicate the environment
  }
}
