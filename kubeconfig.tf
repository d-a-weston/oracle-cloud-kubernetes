resource "null_resource" "kubeconfig" {
  depends_on = [
    oci_core_instance.control_plane
  ]

  provisioner "local-exec" {
    command = templatefile("${path.root}/scripts/kubeconfig.tftpl", {
      control_plane_public_ip = oci_core_instance.control_plane.public_ip
      retry_time              = 10
    })
  }
}
