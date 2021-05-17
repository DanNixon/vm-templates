build {
  sources = [
    "source.proxmox.arch",
    "source.proxmox.arch-btrfs",
  ]

  provisioner "shell" {
    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "truncate -s 0 /etc/machine-id",
    ]
  }
}

build {
  sources = [
    "source.proxmox.ubuntu-focal",
  ]

  provisioner "shell" {
    execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg",
      "cloud-init clean",
      "truncate -s 0 /etc/machine-id",
    ]
  }
}
