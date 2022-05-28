resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key" {
  filename        = "id_rsa.pem"
  file_permission = "0600"
  content         = tls_private_key.ssh.private_key_pem
}

resource "local_file" "ssh_public_key" {
  filename        = "id_rsa.pub"
  file_permission = "0600"
  content         = tls_private_key.ssh.public_key_openssh
}
