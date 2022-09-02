locals {
  admin_groups = var.admin_radiant ? setunion(var.admin_groups, ["radiant_${module.cluster.project_name}"]) : var.admin_groups
}

module "cluster" {
  source = "github.com/ncsa/radiant-cluster/terraform/modules/rke1"

  cluster_name        = var.cluster_name
  cluster_description = var.cluster_description

  rancher_url        = var.rancher_url
  rancher_token      = var.rancher_token
  monitoring_enabled = var.monitoring_enabled
  longhorn_enabled   = var.longhorn_enabled
  longhorn_replicas  = var.longhorn_replicas

  admin_users   = var.admin_users
  admin_groups  = local.admin_groups
  member_users  = var.member_users
  member_groups = var.member_groups

  openstack_url               = var.openstack_url
  openstack_credential_id     = var.openstack_credential_id
  openstack_credential_secret = var.openstack_credential_secret
  #public_key                   = use default in module

  old_hostnames = var.old_hostnames

  controlplane_count    = var.controlplane_count
  controlplane_flavor   = var.controlplane_flavor
  controlplane_disksize = var.controlplane_disksize

  worker_count    = var.worker_count
  worker_flavor   = var.worker_flavor
  worker_disksize = var.worker_disksize

  rke1_version = var.rke1_version

  #network_cidr                 = use default in module
  #dns_servers                  = use default in module
  #floating_ip                  = use default in module
}

module "argocd" {
  source = "github.com/ncsa/radiant-cluster/terraform/modules/argocd"

  cluster_name    = var.cluster_name
  cluster_kube_id = module.cluster.kube_id
  floating_ip     = module.cluster.floating_ip

  openstack_url               = var.openstack_url
  openstack_credential_id     = var.openstack_credential_id
  openstack_credential_secret = var.openstack_credential_secret
  openstack_project           = module.cluster.project_name

  rancher_url   = var.rancher_url
  rancher_token = var.rancher_token

  argocd_master      = var.argocd_enabled ? var.argocd_master : false
  argocd_kube_id     = var.argocd_enabled ? var.argocd_kube_id : ""
  argocd_annotations = var.argocd_annotations
  argocd_sync        = var.argocd_sync

  admin_users   = var.admin_users
  admin_groups  = local.admin_groups
  member_users  = var.member_users
  member_groups = var.member_groups

  # not managed by argocd but rancher
  monitoring_enabled = false
  longhorn_enabled   = false

  # ingress controller
  ingress_controller_enabled = var.ingress_controller_enabled
  ingress_controller         = var.ingress_controller
  ingress_storageclass       = var.ingress_storageclass
  acme_staging               = var.acme_staging
  acme_email                 = var.acme_email
  traefik2_ports             = var.traefik2_ports

  # storage classes
  cinder_enabled = var.cinder_enabled
  nfs_enabled    = var.nfs_enabled

  # load balancer
  metallb_enabled = var.metallb_enabled

  # gitops secrets
  sealedsecrets_enabled = var.sealedsecrets_enabled

  # monitoring services
  healthmonitor_enabled = var.healthmonitor_enabled
  healthmonitor_nfs     = var.healthmonitor_nfs
  healthmonitor_secrets = var.healthmonitor_secrets
}
