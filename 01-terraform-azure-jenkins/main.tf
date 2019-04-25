resource "azurerm_resource_group" "terraform_rg" {
  name 		= "${var.resource_group_name}"
  location 	= "${var.location}"
}

resource "azurerm_virtual_network" "jenkins_vnet" {
  name 			= "${var.network_name}"
  address_space 	= ["${var.vnet_cidr}"]
  location 		= "${var.location}"
  resource_group_name   = "${azurerm_resource_group.terraform_rg.name}"
}

resource "azurerm_subnet" "jenkins_subnet" {
  name 			= "${var.subnet_name}"
  address_prefix 	= "${var.subnet_cidr}"
  virtual_network_name 	= "${azurerm_virtual_network.jenkins_vnet.name}"
  resource_group_name 	= "${azurerm_resource_group.terraform_rg.name}"
}

resource "azurerm_network_security_group" "jenkins_security" {
  name 			= "${var.security_group_name}"
  location 		= "${var.location}"
  resource_group_name 	= "${azurerm_resource_group.terraform_rg.name}"

  security_rule {
	name 			= "AllowSSH"
	priority 		= 100
	direction 		= "Inbound"
	access 		        = "Allow"
	protocol 		= "Tcp"
	source_port_range       = "*"
    destination_port_range     	= "22"
    source_address_prefix      	= "*"
    destination_address_prefix 	= "*"
  }

  security_rule {
	name 			= "AllowHTTP"
	priority		= 200
	direction		= "Inbound"
	access 			= "Allow"
	protocol 		= "Tcp"
	source_port_range       = "*"
    destination_port_range     	= "8080"
    source_address_prefix      	= "Internet"
    destination_address_prefix 	= "*"
  }
}

resource "azurerm_public_ip" "jenkins_pip" {
  name 				= "Jenkins_Public_IP"
  location 			= "${var.location}"
  resource_group_name 		= "${azurerm_resource_group.terraform_rg.name}"
  allocation_method 	= "Static"
}

resource "azurerm_network_interface" "public_nic" {
  name 		      = "Jenkins_Public_NIC"
  location 	      = "${var.location}"
  resource_group_name = "${azurerm_resource_group.terraform_rg.name}"
  network_security_group_id = "${azurerm_network_security_group.jenkins_security.id}"

  ip_configuration {
    name 			= "jenkins-Private"
    subnet_id 			= "${azurerm_subnet.jenkins_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id	= "${azurerm_public_ip.jenkins_pip.id}"
  }
}

resource "azurerm_virtual_machine" "jenkins" {
  name                  = "${var.vm_name}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.terraform_rg.name}"
  network_interface_ids = ["${azurerm_network_interface.public_nic.id}"]
  vm_size               = "${var.vm_size}"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "jenkins-osdisk"
    vhd_uri       = "${azurerm_storage_account.jenkins_storage.primary_blob_endpoint}${azurerm_storage_container.jenkins_cont.name}/osdisk-1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.os_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}


resource "azurerm_virtual_machine_extension" "jenkins_terraform" {
  name                 = "jenkins_extension"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.terraform_rg.name}"
  virtual_machine_name = "${azurerm_virtual_machine.jenkins.name}"
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.2"

  settings = <<SETTINGS
  {
          "fileUris": ["https://raw.githubusercontent.com/lurrelo/Reto-Intercorp/master/jenkins-init.sh"],
          "commandToExecute": "sh jenkins-init.sh"
      }
SETTINGS
}

resource "azurerm_storage_account" "jenkins_storage" {
  name 			= "${var.storage_account_name}"
  resource_group_name 	= "${azurerm_resource_group.terraform_rg.name}"
  location 		= "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "jenkins_cont" {
  name 			= "${var.container_name}"
  resource_group_name 	= "${azurerm_resource_group.terraform_rg.name}"
  storage_account_name 	= "${azurerm_storage_account.jenkins_storage.name}"
  container_access_type = "private"
}
