source "standard" {
  # Packer configuration
  insecure_skip_tls_verify = true
  iso_url                  = "https://mirror.init7.net/ubuntu-releases/22.04.3/ubuntu-22.04.3-live-server-amd64.iso"
  iso_checksum             = "file:https://releases.ubuntu.com/22.04.3/SHA256SUMS"

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
  os      = "l26"
  bios    = "ovmf"
  machine = "q35"
  eficonfig = {
    efi_storage_pool  = "SSD_RAID",
    pre_enrolled_keys = true,
    efi_type          = "4m"
  }

  ## Network
  network_adapters = [
    {
      model  = "virtio"
      bridge = "vmbr0"
      "firewall" : true
    }
  ]
  ## Others
  qeum_agent              = true
  scsi_controller         = "virtio-scsi-single"
  onboot                  = true
  template_name           = "ubuntu-22.04.3-lts-server-standard"
  template_description    = "Ubuntu 22.04.3 LTS Standard Server with 2C4T abd 8GB RAM"
  unmount_iso             = true
  cloud_init              = true
  cloud_init_storage_pool = "HDD_RAID"

  ## Boot commands
  boot_command = [

    "<tab><wait>",
    " ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/centos6-ks.cfg<enter>"
  ]
}
