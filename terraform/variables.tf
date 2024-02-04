# ----------------------------------------------------------------------
# GENERAL
# ----------------------------------------------------------------------

variable "cluster_name" {
  type        = string
  description = "Desired name of new cluster"
}

variable "cluster_description" {
  type        = string
  description = "Description of what cluster is for"
  default     = ""
}

variable "write_ssh_files" {
  type        = bool
  description = "Write out the files to ssh into cluster"
  default     = false
}

# DEPRECATED
variable "write_kubeconfig_files" {
  type        = bool
  description = "Write out the kubeconfig for devops user"
  default     = false
}

# ----------------------------------------------------------------------
# OPENSTACK
# ----------------------------------------------------------------------

variable "openstack_url" {
  type        = string
  description = "OpenStack URL"
  default     = "https://radiant.ncsa.illinois.edu:5000/v3/"
}

variable "openstack_credential_id" {
  type        = string
  sensitive   = true
  description = "Openstack credentials"
}

variable "openstack_credential_secret" {
  type        = string
  sensitive   = true
  description = "Openstack credentials"
}

variable "openstack_external_net" {
  type        = string
  description = "OpenStack external network"
  default     = "ext-net"
}

variable "openstack_security_kubernetes" {
  type        = map(any)
  description = "IP address to allow connections to kube api port, default is rancher nodes"
  default = {
    "rancher-1" : "141.142.218.167/32"
    "rancher-2" : "141.142.217.171/32"
    "rancher-3" : "141.142.217.184/32"
  }
}

variable "openstack_security_ssh" {
  type        = map(any)
  description = "IP address to allow connections to ssh, default is open to the NCSA"
  default = {
    "ncsa" : "141.142.0.0/16"
  }
}

# DEPRECATED
variable "openstack_zone" {
  type        = string
  description = "default zone to use for openstack nodes"
  default     = "nova"
}

# ----------------------------------------------------------------------
# KUBERNETES NODES
# ----------------------------------------------------------------------

# curl -s https://releases.rancher.com/kontainer-driver-metadata/release-v2.8/data.json | jq -r '.K8sVersionRKESystemImages | keys'
variable "rke1_version" {
  type        = string
  description = "Version of rke1 to install."
  default     = "v1.27.8-rancher2-2"
}

# DEPRECATED
variable "old_hostnames" {
  type        = bool
  description = "should old hostname be used (base 0)"
  default     = false
}

# DEPRECATED
variable "controlplane_count" {
  type        = string
  description = "Desired quantity of control-plane nodes"
  default     = 3
}

# DEPRECATED
variable "controlplane_flavor" {
  type        = string
  description = "Desired flavor of control-plane nodes"
  default     = "gp.medium"
}

# DEPRECATED
variable "controlplane_disksize" {
  type        = string
  description = "Desired disksize of control-plane nodes"
  default     = 40
}

# DEPRECATED
variable "worker_count" {
  type        = string
  description = "Desired quantity of worker nodes"
  default     = 3
}

# DEPRECATED
variable "worker_flavor" {
  type        = string
  description = "Desired flavor of worker nodes"
  default     = "gp.large"
}

# DEPRECATED
variable "worker_disksize" {
  type        = string
  description = "Desired disksize of worker nodes"
  default     = 40
}

# ----------------------------------------------------------------------
# NODE CREATION OPTIONS
# ----------------------------------------------------------------------

variable "ncsa_security" {
  type        = bool
  description = "Install NCSA security options, for example rsyslog"
  default     = false
}

variable "taiga_enabled" {
  type        = bool
  description = "Enable Taiga mount"
  default     = true
}

variable "install_docker" {
  type        = bool
  description = "Install Docker when provisioning node"
  default     = true
}

# ----------------------------------------------------------------------
# RANCHER
# ----------------------------------------------------------------------
variable "rancher_url" {
  type        = string
  description = "URL where rancher runs"
  default     = "https://gonzo-rancher.ncsa.illinois.edu"
}

variable "rancher_token" {
  type        = string
  sensitive   = true
  description = "Access token for rancher, clusters are created as this user"
}

# ----------------------------------------------------------------------
# USERS
# ----------------------------------------------------------------------

# DEPRECATED
variable "admin_radiant" {
  type        = bool
  description = "Should users that have access to radiant be an admin"
  default     = false
}

variable "admin_users" {
  type        = set(string)
  description = "List of all users that have admin rights in argocd and the cluster"
  default     = []
}

variable "admin_groups" {
  type        = set(string)
  description = "List of all groups that have admin rights in argocd and the cluster"
  default     = []
}

variable "member_users" {
  type        = set(string)
  description = "List of all users that have access rights in argocd and the cluster"
  default     = []
}

variable "member_groups" {
  type        = set(string)
  description = "List of all groups that have access rights in argocd and the cluster"
  default     = []
}

# ----------------------------------------------------------------------
# ARGOCD
# ----------------------------------------------------------------------
variable "argocd_enabled" {
  type        = bool
  description = "Should argocd resources be created"
  default     = true
}

variable "argocd_repo_version" {
  type        = string
  description = "What version of the application to deploy"
  default     = "HEAD"
}

variable "argocd_sync" {
  type        = bool
  description = "Should apps automatically sync"
  default     = false
}

variable "argocd_annotations" {
  type        = set(string)
  description = "Send notifications in case anything changes."
  default     = []
}

variable "argocd_kube_id" {
  type        = string
  description = "Rancher kube id for argocd cluster"
  default     = "c-ls9dp"
}

# ----------------------------------------------------------------------
# APPLICATIONS (some rancher, some argocd)
# ----------------------------------------------------------------------

variable "argocd_app" {
  type        = bool
  description = "Deploy longhorn/monitoring using argocd"
  default     = false
}

variable "monitoring_enabled" {
  type        = bool
  description = "Enable monitoring in rancher"
  default     = true
}

variable "cinder_enabled" {
  type        = bool
  description = "Enable cinder storage"
  default     = false
}

# will change to false in future version
variable "longhorn_enabled" {
  type        = bool
  description = "Enable longhorn storage"
  default     = true
}

variable "longhorn_replicas" {
  type        = string
  description = "Number of replicas"
  default     = 3
}

variable "nfs_enabled" {
  type        = bool
  description = "Enable NFS storage"
  default     = true
}

# will change to false in future version
variable "healthmonitor_enabled" {
  type        = bool
  description = "Enable healthmonitor"
  default     = true
}

variable "healthmonitor_nfs" {
  type        = bool
  description = "Enable healthmonitor nfs"
  default     = true
}

variable "healthmonitor_secrets" {
  type        = string
  description = "Secrets (config/checks/notifications) for healthmonitor"
  default     = "config"
}

variable "sealedsecrets_enabled" {
  type        = bool
  description = "Enable sealed secrets"
  default     = false
}

variable "metallb_enabled" {
  type        = bool
  description = "Enable MetalLB"
  default     = true
}

variable "floating_ip" {
  type        = string
  description = "Number of floating IPs for MetalLB"
  default     = 2
}

# ----------------------------------------------------------------------
# INGRESS
# ----------------------------------------------------------------------

variable "ingress_controller_enabled" {
  type        = bool
  description = "Enable IngressController"
  default     = true
}

variable "ingress_controller" {
  type        = string
  description = "Desired ingress controller (traefik, traefik2 (same as traefik), nginx, none)"
  default     = "traefik"
}

# ----------------------------------------------------------------------
# TRAEFIK
# ----------------------------------------------------------------------

variable "traefik_storageclass" {
  type        = string
  description = "storageclass used by ingress controller"
  default     = "nfs-taiga"
}

variable "traefik_ports" {
  type        = map(any)
  description = "Additional ports to add to traefik"
  default     = {}
}

# ----------------------------------------------------------------------
# LETS ENCRYPT
# ----------------------------------------------------------------------

variable "acme_staging" {
  type        = bool
  description = "Use the staging server"
  default     = false
}

variable "acme_email" {
  type        = string
  description = "Use the following email for cert messages"
  default     = "devops.isda@lists.illinois.edu"
}
