# Variable Definitions
variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}


variable "storage_pool" {
  type    = string
}


variable "cloud_init_storage_pool" {
  type    = string
}

variable "iso_storage_pool" {
  type    = string
}

variable "node" {
  type = string
}

variable "iso_file" {
  type = string
}

variable "disk_format" {
  type    = string
  default = "qcow2"
}