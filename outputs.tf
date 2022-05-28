output "ssh-control-plane" {
  value = "ssh -l ubuntu -p 22 -i ${local_file.ssh_private_key.filename} ${oci_core_instance.control_plane.public_ip}"
}

output "ssh-workers" {
  value = join(
    "\n",
    [for instance in oci_core_instance.worker :
      "ssh -l ubuntu -p 22 -i ${local_file.ssh_private_key.filename} ${instance.public_ip} # ${instance.display_name}"
    ]
  )
}
