locals {
  ssh_key_file_location = "~/.ssh/ckad.pem"
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "pem_file" {
  content              = tls_private_key.key.private_key_pem
  filename             = pathexpand(local.ssh_key_file_location)
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "aws_key_pair" "key" {
  key_name   = "aws-ssh-key"
  public_key = tls_private_key.key.public_key_openssh
}
