resource "local_file" "ssh_private_key" {
  count                = var.write_ssh_files ? 1 : 0
  filename             = pathexpand("~/.ssh/${var.cluster_name}.pem")
  directory_permission = "0700"
  file_permission      = "0600"
  content              = module.cluster.private_key_ssh
}

resource "local_file" "ssh_config" {
  count                = var.write_ssh_files ? 1 : 0
  filename             = pathexpand("~/.ssh/config.d/${var.cluster_name}")
  directory_permission = "0700"
  file_permission      = "0600"
  content              = module.cluster.ssh_config
}
