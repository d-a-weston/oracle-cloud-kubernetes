resource "oci_core_vcn" "kubernetes_vcn" {
  compartment_id = oci_identity_compartment.kubernetes_compartment.id
  cidr_block     = var.vcn_cidr
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = oci_identity_compartment.kubernetes_compartment.id
  vcn_id         = oci_core_vcn.kubernetes_vcn.id
}

resource "oci_core_default_route_table" "default_rt" {
  manage_default_resource_id = oci_core_vcn.kubernetes_vcn.default_route_table_id

  # Default route to IGW
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

resource "oci_core_default_security_list" "default_sl" {
  manage_default_resource_id = oci_core_vcn.kubernetes_vcn.default_security_list_id

  # Allow all Ingress
  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"
  }

  # Allow all Egress
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "kubernetes_subnet" {
  compartment_id = oci_identity_compartment.kubernetes_compartment.id

  cidr_block        = var.kubernetes_subnet_cidr
  vcn_id            = oci_core_vcn.kubernetes_vcn.id
  route_table_id    = oci_core_default_route_table.default_rt.id
  security_list_ids = [oci_core_default_security_list.default_sl.id]
}
