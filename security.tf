resource "oci_identity_compartment" "kubernetes_compartment" {
  name          = var.project_name
  description   = var.project_name
  enable_delete = true
}
