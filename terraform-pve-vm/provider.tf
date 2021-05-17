terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.6.6"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "${var.pve_url}/api2/json"
  pm_user         = var.pve_user
  pm_password     = var.pve_password
  pm_tls_insecure = true
}
