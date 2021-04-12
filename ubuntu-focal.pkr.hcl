source "proxmox" "ubuntu-focal" {
  proxmox_url              = "${var.pve_url}"
  username                 = "${var.pve_username}"
  password                 = "${var.pve_password}"
  node                     = "${var.pve_node}"
  insecure_skip_tls_verify = true

  template_name = "ubuntu-focal"
  vm_id         = 9001

  http_directory = "http/ubuntu-focal"

  os          = "l26"
  qemu_agent  = true
  iso_file    = "local:iso/ubuntu-20.04-live-server-amd64.iso"
  unmount_iso = true

  boot = "order=scsi0;ide2"
  boot_command = [
    "<enter><enter><f6><esc><wait> ",
    "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<wait3><enter><wait>",
  ]
  boot_wait = "3s"

  cores  = 2
  memory = 2048

  disks {
    type              = "scsi"
    disk_size         = "8G"
    storage_pool_type = "zfspool"
    storage_pool      = "local-zfs"
  }
  scsi_controller = "virtio-scsi-single"

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }

  cloud_init              = true
  cloud_init_storage_pool = "local-zfs"

  ssh_username = "automation"
  ssh_password = "please_change_me_i_am_not_safe"
  ssh_timeout  = "20m"
}
