resource "oci_core_instance" "control_plane" {
  display_name        = "kubernetes-control-plane"
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
}

resource "oci_core_instance" "worker" {
  count = var.worker_count

  display_name        = "kubernetes-worker-${count.index}"
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
}
