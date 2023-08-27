resource "azurerm_network_interface" "main" {
  name                = "${var.application_type}-${var.resource_type}-NI"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.application_type}-${var.resource_type}-VM"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  size                = "Standard_DS2_v2"
  admin_username      = "${var.admin_username}"
  network_interface_ids = [azurerm_network_interface.main.id]
  admin_ssh_key {
    username   = "adminuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqKDOj/X1O/wyNHiMNbx3iuDaj/z/CLiX4PSL8VnaxT8CqSoN66AE+rtru3ZHv7WVIg6IarjrGO946YAH8NmH6zmKVhLhKL/VB1KKJnp67SD+LMLRxW2tBab3JbdArT00ZTK10E6U62OxLXoRotiic4OAVdrFK33CQ3PV3FOYOzX1K6WJNdTtof6EuiDc3EoZBa2rjpYM5mGtGklv4o4dvEqPBj2yOep0OniLFUpFfqZ56MfsxOTf8KwrJy2wtgCbxdZSCltX64rfG6alcEpCQBYeO5OZqJaYBBUQY0g4YXf5q+EIpcufR8QiuwFSRaKgO55bHQWAFndrY2VjaDo8a9w0Q6K/QJ6JKgeGujHIrEi290LPHnmjnGmiWuHQqIiskOuP2sjPq/z70mSxFwj/bd5mQs7x5U8R/rO3gVZ+3SSwVLilVGIaaDlFvLKILNFOObTO2UaWj+wGsQLqhJ+Dv+p598MW4NZRz3dMx4DVIdrRpKm7x7XdXFaQ2C8HsSTU= odl_user@cc-a48a66ae-d89974b9b-vwkhp"
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
