source "standard" {
  # Packer configuration
  insecure_skip_tls_verify = true

  # VM configuration
  ## Hardware
  memory   = 8192
  cores    = 2
  sockets  = 2
  cpu_type = "kvm64"
  disk = {
    type         = "scsi"
    storage_pool = "SSD_RAID"
    disk_size    = "30G"
    ssd          = true
    format       = "qcow2"
  }

  ## OS and BIOS
  os      = "l25"
  bios    = "ovmf"
  machine = "q35"
  eficonfig = {
    efi_storage_pool  = "SSD_RAID",
    pre_enrolled_keys = true,
    efi_type          = "4m"
  }

  ## Others
  qeum_agent      = true
  scsi_controller = "virtio-scsi-single"
  onboot          = true

}
