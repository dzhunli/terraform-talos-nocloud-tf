# Smallest useful setup: 1 control plane + 1 worker, DHCP (use reservations!), Flannel CNI.
terraform {
  required_version = ">= 1.5.0"
}

module "talos" {
  source = "../.."

  cluster_name     = "lab"
  cluster_endpoint = "https://192.168.0.62:6443"

  talos_version        = "v1.14.5"
  kubernetes_version   = "1.36.0"
  default_install_disk = "/dev/sda"

  auto_upgrade = {
    enabled = true
  }

  image_profiles = {
    default = {
      system_extensions = ["intel-ucode", "iscsi-tools", "util-linux-tools"]
    }
  }

  allow_non_ha = true      # dev only
  cni          = "flannel" # works out of the box

  nodes = {
    cp-1 = { role = "controlplane", ip = "192.168.0.62" }
    w-1  = { role = "worker", ip = "192.168.0.108" }
  }
}


output "kubeconfig" {
  value     = module.talos.kubeconfig
  sensitive = true
}
output "talosconfig" {
  value     = module.talos.talosconfig
  sensitive = true
}
output "iso_urls" { value = module.talos.iso_urls }
output "nodes" { value = module.talos.nodes }
