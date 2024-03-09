source "proxmox-iso" "memory-optimized" {

  # Proxmox Connection Settings
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true
  # iso_url                  = "https://mirror.init7.net/ubuntu-releases/22.04.3/ubuntu-22.04.3-live-server-amd64.iso"
  # iso_checksum             = "file:https://releases.ubuntu.com/22.04.3/SHA256SUMS"
  iso_file     = "WD_MASS:iso/ubuntu-22.04.3-live-server-amd64.iso"
  node         = "pve"
  vm_id        = "10005"
  ssh_username = "ubuntu"
  ssh_password = "ubuntu"
  ssh_timeout  = "20m"

  # VM configuration
  ## Hardware
  memory   = 32768
  cores    = 4
  sockets  = 2
  cpu_type = "x86-64-v2-AES"
  disks {
    type         = "scsi"
    storage_pool = "SSD_RAID"
    disk_size    = "120G"
    ssd          = true
    format       = "qcow2"
  }

  ## OS and BIOS
  os      = "l26"
  bios    = "ovmf"
  machine = "pc"
  efi_config {
    efi_storage_pool  = "SSD_RAID"
    pre_enrolled_keys = true
    efi_type          = "4m"
  }

  ## Network
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }

  ## Others
  qemu_agent           = true
  scsi_controller      = "virtio-scsi-single"
  onboot               = true
  template_name        = "ubuntu-22.04.3-lts-server-memory-optimized"
  template_description = "Ubuntu 22.04.3 LTS Memory Optimized Server with 4C2T and 32GB RAM"
  unmount_iso          = true

  # Cloud-init configuration
  cloud_init              = true
  cloud_init_storage_pool = "WD_MASS"
  # http_directory          = "http"
  # http_port_min           = 12234
  # http_port_max           = 12234
  additional_iso_files {
    cd_files = [
      "./http/meta-data",
      "./http/user-data"
    ]
    cd_label         = "cidata"
    iso_storage_pool = "WD_MASS"
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