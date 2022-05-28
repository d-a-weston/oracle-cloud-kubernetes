data "oci_core_images" "ubuntu" {
  compartment_id           = oci_identity_compartment.kubernetes_compartment.id
  shape                    = var.instance_shape
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.04"
}

data "oci_identity_availability_domains" "available" {
  compartment_id = oci_identity_compartment.kubernetes_compartment.id
}
