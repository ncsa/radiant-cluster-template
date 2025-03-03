output "private_key_ssh" {
  description = "Private SSH key"
  sensitive   = true
  value       = module.cluster.private_key_ssh
}

output "key_name" {
  description = "SSH key"
  value       = module.cluster.key_name
}

output "ssh_config" {
  description = "SSH Configuration, can be used to ssh into cluster"
  sensitive   = true
  value       = module.cluster.ssh_config
}

output "kubeconfig" {
  description = "Access to cluster as cluster owner"
  sensitive   = true
  value       = module.cluster.kubeconfig
}

output "kube_id" {
  description = "ID of rancher cluster"
  value       = module.cluster.kube_id
}

output "floating_ip" {
  description = "Map for floating ips and associated private ips"
  value       = module.cluster.floating_ip
}

output "openstack_project" {
  description = "OpenStack project name"
  value       = module.cluster.project_name
}
