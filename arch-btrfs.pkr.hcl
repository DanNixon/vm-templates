source "proxmox" "arch-btrfs" {
  proxmox_url              = "${var.pve_url}"
  username                 = "${var.pve_username}"
  password                 = "${var.pve_password}"
  node                     = "${var.pve_node}"
  insecure_skip_tls_verify = true

  template_name = "arch-btrfs"
  vm_id         = 9002

  http_directory = "http/arch-btrfs"

  os          = "l26"
  qemu_agent  = true
  iso_file    = "local:iso/archlinux-2021.02.01-x86_64.iso"
  unmount_iso = true

  boot = "order=scsi0;ide2"
  boot_command = [
    "<Enter><wait30>",
    "curl -o install.sh http://{{ .HTTPIP }}:{{ .HTTPPort }}/install.sh<Enter><wait5>",
    "curl -o config.sh http://{{ .HTTPIP }}:{{ .HTTPPort }}/config.sh<Enter><wait5>",
    "sh install.sh<Enter>",
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
  ssh_timeout  = "5m"
}
