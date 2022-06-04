# Kubeadm Token used for joining the cluster together
# Regex Format: "[a-z0-9]{6}.[a-z0-9]{16}"
# https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-token/
locals {
  kubeadm_token = "${random_string.kubeadm_token_part_1.result}.${random_string.kubeadm_token_part_2.result}"
}

resource "random_string" "kubeadm_token_part_1" {
  length = 6

  special = false
  upper   = false
}

resource "random_string" "kubeadm_token_part_2" {
  length = 16

  special = false
  upper   = false
}

# Key for Google Cloud apt repo
data "http" "kubernetes_apt_repo_key" {
  url = "https://packages.cloud.google.com/apt/doc/apt-key.gpg.asc"
}

data "cloudinit_config" "control_plane" {
  # Contains the common cloud-init config for all nodes
  part {
    filename     = "cloud-config.cfg"
    content_type = "text/cloud-config"
    content = templatefile("${path.root}/config/cloud_config.tftpl", {
      hostname            = var.control_plane_display_name
      kubernetes_repo_key = data.http.kubernetes_apt_repo_key.body
      kubeadm_token       = local.kubeadm_token
      tls_public_key      = tls_private_key.ssh.public_key_openssh
      tls_private_key     = tls_private_key.ssh.private_key_pem
    })
  }

  # Adds the kubeadm config to the control plane node
  part {
    filename     = "kubeadm-config.cfg"
    content_type = "text/cloud-config"
    content = templatefile("${path.root}/config/kubeadm_config.tftpl", {
      kubeadm_token = local.kubeadm_token
    })
  }

  # Script to initialize the control plane node
  # Enables all traffic, initializes kubeadm, and then installs Flannel CNI
  part {
    filename     = "kubeadm_init.sh"
    content_type = "text/x-shellscript"
    content      = file("${path.root}/config/kubeadm_init.sh")
  }
}

data "cloudinit_config" "worker" {
  count = var.worker_count

  # Contains the common cloud-init config for all nodes
  part {
    filename     = "cloud-config.cfg"
    content_type = "text/cloud-config"
    content = templatefile("${path.root}/config/cloud_config.tftpl", {
      hostname            = "${var.worker_display_name_prefix}-${count.index}"
      kubernetes_repo_key = data.http.kubernetes_apt_repo_key.body
      kubeadm_token       = local.kubeadm_token
      tls_public_key      = tls_private_key.ssh.public_key_openssh
      tls_private_key     = tls_private_key.ssh.private_key_pem
    })
  }

  # Script for joining the worker nodes to the cluster
  # Enables all traffic, waits for the control plane to be ready, and then joins
  part {
    filename     = "kubeadm_join.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.root}/config/kubeadm_join.tftpl", {
      control_plane_private_ip = "${var.control_plane_private_ip}:6443"
      kubeadm_token            = local.kubeadm_token
      retry_time               = 10
    })
  }
}
