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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDl1j0VK0xJJKZSeR5B7zlEPoiLFPRyxDRS1RrHf0Dmle6PCguS5xli5XO0v9xCtZHQHFzUOCj+hYAUKYHd0Fpz11ptgC2rR9JRUoBdXztGQeBNbomk3Nmoaub17MrhXX5ZVxIbqD9S50n+Cslt1Y2ocgAIUCHhG5YNu+Ir76992xmYIENu+wzF+L6Swr/x6lNSwFxRwTNsc17lTdiotIBrf5nWvE11eXmeHVKYjCLwMxwU6v1yHnnyXmAuZqj/K18F/suj9XEdFk3WWyB15QQmMNTfj4iVmwo20yMzmkZKFOevdgnBHWE4iCnzGVRwYFYyQa2emqQu06I6PK4eK6qcGtDz2TXyKRre/pULl3TZhabqvB8qudNIQ+g7p5udBNgkBn9/W1/0VKOwppsncAEvqrZqReKS4M6f2kPqDc0Zv3ylM3LTgWCQzAQBgaUw7j88n74iKxFgridrpcjfzXtq0vmHn4N1A5DOs6v+e149Jd7JmhOdZcauGtDH+E0pkYE= thanhducnguyen0511@cc-159c10c9-5cb96cf6bc-mnkrc"
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
