source "proxmox-iso" "standard" {

  # Proxmox Connection Settings
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true
  # iso_url                  = "https://mirror.init7.net/ubuntu-releases/24.04.3/ubuntu-24.04.3-live-server-amd64.iso"
  # iso_checksum             = "file:https://releases.ubuntu.com/24.04.3/SHA256SUMS"
  iso_file     = var.iso_file
  node         = var.node
  vm_id        = "10007"
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "20m"

  # VM configuration
  ## Hardware
  memory   = 8192
  cores    = 2
  sockets  = 2
  cpu_type = "x86-64-v2-AES"
  disks {
    type         = "scsi"
    storage_pool = var.storage_pool
    disk_size    = "30G"
    ssd          = true
    format       = "qcow2"
  }

  ## OS and BIOS
  os      = "l26"
  bios    = "ovmf"
  machine = "pc"
  efi_config {
    efi_storage_pool  = var.storage_pool
    pre_enrolled_keys = true
    efi_type          = "4m"
  }

  ## Network
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr1"
    vlan_tag = 20
    firewall = true
  }

  ## Others
  qemu_agent           = true
  scsi_controller      = "virtio-scsi-single"
  onboot               = true
  template_name        = "ubuntu-24.04-lts-server-standard"
  template_description = "Ubuntu 24.04 LTS Standard Server with 2C4T and 8GB RAM"
  unmount_iso          = true

  # Cloud-init configuration
  cloud_init              = true
  cloud_init_storage_pool = var.cloud_init_storage_pool
  # http_directory          = "http"
  # http_port_min           = 12234
  # http_port_max           = 12234
  additional_iso_files {
    cd_files = [
      "./http/meta-data",
      "./http/user-data"
    ]
    type = "scsi"
    cd_label         = "cidata"
    iso_storage_pool = var.iso_storage_pool
    unmount          = true
  }


  ## Boot options
  boot_wait = "10s"
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net;s=/cidata/ ---<wait>",
    "<f10><wait>"
  ]
}
