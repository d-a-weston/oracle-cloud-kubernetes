resource "oci_core_instance" "control_plane" {
  display_name        = var.control_plane_display_name
  availability_domain = data.oci_identity_availability_domains.available.availability_domains[var.availability_domain].name
  compartment_id      = oci_identity_compartment.kubernetes_compartment.id
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_cpu
    memory_in_gbs = var.instance_memory
  }

  source_details {
    source_id   = data.oci_core_images.ubuntu.images[0].id
    source_type = "image"
  }

  create_vnic_details {
    subnet_id  = oci_core_subnet.kubernetes_subnet.id
    private_ip = var.control_plane_private_ip
  }

  metadata = {
    ssh_authorized_keys = trimspace(tls_private_key.ssh.public_key_openssh)
    user_data           = data.cloudinit_config.control_plane.rendered
  }
}

resource "oci_core_instance" "worker" {
  count = var.worker_count

  display_name        = "${var.worker_display_name_prefix}-${count.index}"
  availability_domain = data.oci_identity_availability_domains.available.availability_domains[var.availability_domain].name
  compartment_id      = oci_identity_compartment.kubernetes_compartment.id
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_cpu
    memory_in_gbs = var.instance_memory
  }

  source_details {
    source_id   = data.oci_core_images.ubuntu.images[0].id
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.kubernetes_subnet.id
  }

  metadata = {
    ssh_authorized_keys = trimspace(tls_private_key.ssh.public_key_openssh)
    user_data           = data.cloudinit_config.worker[count.index].rendered
  }

  lifecycle {
    replace_triggered_by = [
      oci_core_instance.control_plane
    ]
  }
}
