variable "pve_url" {
  type = string
}

variable "pve_user" {
  type    = string
  default = "root@pam"
}

variable "pve_password" {
  type = string
}

variable "pve_node" {
  type    = string
  default = "pve1"
}

variable "instances" {
  type    = number
  default = 1
}

variable "name" {
  description = "Name of the VM"
  type        = string
}

variable "description" {
  description = "Sensible description of VM"
  type        = string
  default     = "VM McVMface"
}

variable "image" {
  description = "Name of template to clone from"
  type        = string
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Amount of main memory"
  type        = number
  default     = 2048
}

variable "storage" {
  description = "Size of disk storage"
  type        = string
  default     = "16G"
}

variable "start_on_node_boot" {
  description = "If the VM should be started when the node boots"
  type        = bool
  default     = false
}

variable "automation_user_ssh_pubkey" {
  description = "SSH public key for the automation user"
  type        = string
}
