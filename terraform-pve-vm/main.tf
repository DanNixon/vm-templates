resource "proxmox_vm_qemu" "machines" {
  name = var.name
  desc = var.description

  target_node = var.pve_node

  clone = var.image
  boot  = "order=scsi0"
  agent = 1

  onboot = var.start_on_node_boot
  cores  = var.cores
  memory = var.memory

  os_type   = "cloud-init"
  ipconfig0 = "ip=dhcp"

  network {
    model   = "virtio"
    bridge  = "vmbr0"
    macaddr = var.mac_address
    tag     = var.vlan_id
  }

  disk {
    type    = "scsi"
    storage = "local-zfs"
    size    = var.storage
  }

  provisioner "file" {
    connection {
      type     = "ssh"
      user     = "automation"
      password = "please_change_me_i_am_not_safe"
      host     = self.ssh_host
    }
    source      = "${path.module}/provision_scripts/disk_${var.image}.sh"
    destination = "/tmp/disk.sh"
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "automation"
      password = "please_change_me_i_am_not_safe"
      host     = self.ssh_host
    }
    inline = [
      "mkdir -p $HOME/.ssh",
      "echo \"${var.automation_user_ssh_pubkey}\" > $HOME/.ssh/authorized_keys",
      "chmod +x /tmp/disk.sh",
      "sudo /tmp/disk.sh",
      "rm /tmp/disk.sh",
      "sudo passwd -d automation",
      "sudo passwd -l automation",
    ]
  }
}
