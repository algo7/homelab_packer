source "proxmox-iso" "standard" {

  # Proxmox Connection Settings
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true
  # iso_url                  = "https://mirror.init7.net/ubuntu-releases/22.04.3/ubuntu-22.04.3-live-server-amd64.iso"
  # iso_checksum             = "file:https://releases.ubuntu.com/22.04.3/SHA256SUMS"
  iso_storage_pool = "WD_MASS"
  iso_file         = "WD_MASS:iso/ubuntu-22.04.3-live-server-amd64.iso"
  node             = "pve"
  ssh_username     = "ubuntu"
  ssh_password     = "ubuntu"
  ssh_timeout      = "20m"

  # VM configuration
  ## Hardware
  memory   = 8192
  cores    = 2
  sockets  = 2
  cpu_type = "x86-64-v2-AES"
  disks {
    type         = "scsi"
    storage_pool = "SSD_RAID"
    disk_size    = "30G"
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
  template_name        = "ubuntu-22.04.3-lts-server-standard"
  template_description = "Ubuntu 22.04.3 LTS Standard Server with 2C4T abd 8GB RAM"
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

# Build Definition to create the VM Template
build {

  name    = "ubuntu-server-jammy"
  sources = ["source.proxmox-iso.standard"]

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync"
    ]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
  provisioner "file" {
    source      = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
  provisioner "shell" {
    inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }

  # Add additional provisioning scripts here
  # ...
}
