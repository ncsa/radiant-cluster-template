locals {
  cluster_def = jsondecode(file("cluster.json"))
  machines    = local.cluster_def["machines"]

  ports = { for k, v in var.traefik_ports : k => {
    "port_range_min" : v.exposedPort,
    "port_range_max" : v.exposedPort,
    "protocol" : try(v.protocol, "TCP"),
    "remote_ip_prefix" : try(v.ipPrefix, "0.0.0.0/0"),
  } if v.expose }
}


module "cluster" {
  source  = "git.ncsa.illinois.edu/kubernetes/rke1/radiant"
  version = ">= 3.0.0, < 4.0.0"

  cluster_name        = var.cluster_name
  cluster_description = var.cluster_description
  cluster_machines    = local.machines

  openstack_url                 = var.openstack_url
  openstack_credential_id       = var.openstack_credential_id
  openstack_credential_secret   = var.openstack_credential_secret
  openstack_security_kubernetes = var.openstack_security_kubernetes
  openstack_security_ssh        = var.openstack_security_ssh
  openstack_security_custom     = merge(local.ports, var.openstack_security_custom)

  ncsa_security  = var.ncsa_security
  taiga_enabled  = var.taiga_enabled
  install_docker = var.install_docker

  floating_ip = var.floating_ip

  rancher_url    = var.rancher_url
  rancher_token  = var.rancher_token
  rke1_version   = var.rke1_version
  network_plugin = var.network_plugin

  admin_users   = var.admin_users
  admin_groups  = var.admin_groups
  member_users  = var.member_users
  member_groups = var.member_groups

  #network_cidr                 = use default in module
  #dns_servers                  = use default in module
  #floating_ip                  = use default in module
}

module "argocd" {
  source  = "git.ncsa.illinois.edu/kubernetes/argocd/radiant"
  version = ">= 3.0.0, < 4.0.0"

  cluster_name    = var.cluster_name
  cluster_kube_id = module.cluster.kube_id
  floating_ip     = module.cluster.floating_ip

  openstack_url               = var.openstack_url
  openstack_credential_id     = var.openstack_credential_id
  openstack_credential_secret = var.openstack_credential_secret
  openstack_project           = module.cluster.project_name

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  argocd_repo_version = var.argocd_repo_version
  argocd_kube_id      = var.argocd_enabled ? var.argocd_kube_id : ""
  argocd_annotations  = var.argocd_annotations
  argocd_sync         = var.argocd_sync

  admin_users   = var.admin_users
  admin_groups  = var.admin_groups
  member_users  = var.member_users
  member_groups = var.member_groups


  # ingress controller
  ingress_controller_enabled = var.ingress_controller_enabled
  ingress_controller         = var.ingress_controller
  traefik_storageclass       = var.traefik_storageclass
  traefik_ports              = var.traefik_ports
  acme_staging               = var.acme_staging
  acme_email                 = var.acme_email

  # storage classes
  cinder_enabled    = var.cinder_enabled
  nfs_enabled       = var.nfs_enabled
  longhorn_enabled  = var.longhorn_enabled
  longhorn_replicas = var.longhorn_replicas

  # load balancer
  metallb_enabled = var.metallb_enabled

  # gitops secrets
  sealedsecrets_enabled = var.sealedsecrets_enabled

  # monitoring services
  monitoring_enabled    = var.monitoring_enabled
  healthmonitor_enabled = var.healthmonitor_enabled
  healthmonitor_nfs     = var.healthmonitor_nfs
  healthmonitor_secrets = var.healthmonitor_secrets
}
