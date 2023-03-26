terraform {
  required_providers {
    proxmox = {
      source = "terraform.local/telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url = "<node_api_url>" # which node using to create vm
  pm_api_token_id = "<token_id>" 
  pm_api_token_secret = "<token>"
  pm_tls_insecure = true
}
resource "proxmox_vm_qemu" "test_server" {
  name = var.name_vm
  target_node var.proxmox_host
  clone = var.template_name
  agent = 0
  os_type = "cloud-init"
  core = var.template_cores
  sockets = var.template_sockets
  cpu = "host"
  memory = var.template_memory
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    # set disk size here. Leave it small for testing because expanding the disk takes time.
    size = "50G"
    type = "scsi"
    storage = "local-lvm"
    iothread = 0
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
    firewall = "true"
    link_down = "false"
  }
  # not sure exactly what this is for. Presumably something about MAC address and ignore changes
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  ipconfig0 = "ip=${var.ip_address}/24,gw=<gw_address>"

  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

  connection {
    timeout  = "10m"
    type     = "ssh"
    user     = var.user_name
    password = var.root_password
    host     = "${var.ip_address}"
    agent    = false
    private_key = file(pathexpand("~/.ssh/id_rsa"))
    }
  provisioner "file" {
    source      = "<source files>" # The files or directory you want to copy to the new virtual machine.
    destination = "<destination directory>"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
    ]
  }
}
