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

# ----------------------------------------------------------------------
# OPENSTACK
# ----------------------------------------------------------------------

variable "openstack_url" {
  type        = string
  description = "OpenStack URL"
  default     = "https://radiant.ncsa.illinois.edu:5000/v3/"
}

variable "openstack_region_name" {
  type        = string
  description = "OpenStack region name"
  default     = "RegionOne"
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
    "rancher-01" : "141.142.219.189/32"
    "rancher-02" : "141.142.216.186/32"
    "rancher-03" : "141.142.218.118/32"
  }
}

variable "openstack_security_ssh" {
  type        = map(any)
  description = "IP address to allow connections to ssh, default is open to the NCSA"
  default = {
    "ncsa" : "141.142.0.0/16"
  }
}

variable "openstack_security_custom" {
  type        = map(any)
  description = "ports to open for custom services to the world, assumed these are blocked in other ways"
  default = {
  }
}

variable "openstack_os_image" {
  type        = map(any)
  description = "Map from short OS name to image"
  default = {
    "ubuntu" = {
      "imagename" : "Ubuntu 22.04"
      "username" : "ubuntu"
    }
    "ubuntu22" = {
      "imagename" : "Ubuntu 22.04"
      "username" : "ubuntu"
    }
    "ubuntu24" = {
      "imagename" : "Ubuntu 24.04"
      "username" : "ubuntu"
    }
  }
}

variable "openstack_ssh_key" {
  type        = string
  description = "OpenStack SSH key name, leave blank to generate new key"
  default     = ""
}

variable "dns_servers" {
  type        = set(string)
  description = "DNS Servers"
  default     = ["141.142.2.2", "141.142.230.144"]
}

# ----------------------------------------------------------------------
# NODE CREATION OPTIONS
# ----------------------------------------------------------------------

variable "k8s_cis_hardening" {
  type        = bool
  description = "Install host-level and kubernetes-level security options for CIS Benchmark compliance"
  default     = false
}

variable "ncsa_security" {
  type        = bool
  description = "Install NCSA security options, for example rsyslog"
  default     = false
}

variable "qualys_url" {
  type        = string
  description = "When installing qualys-cloud-agent, the URL to download the agent from"
  default     = ""
}

variable "qualys_activation_id" {
  type        = string
  description = "When installing qualys-cloud-agent, this is the activation id"
  default     = ""
}

variable "qualys_customer_id" {
  type        = string
  description = "When installing qualys-cloud-agent, this is the customer id"
  default     = ""
}

variable "qualys_server" {
  type        = string
  description = "When installing qualys-cloud-agent, this is the server to connect to"
  default     = ""
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

# NEW
# RKE2
# curl -s https://releases.rancher.com/kontainer-driver-metadata/release-v2.11/data.json | jq -r '.rke2.releases[].version'
# K3S
# curl -s https://releases.rancher.com/kontainer-driver-metadata/release-v2.11/data.json | jq -r '.k3s.releases[].version'
variable "kubernetes_version" {
  type        = string
  description = "Version of rke1 to install."
  default     = ""
}

# curl -s https://releases.rancher.com/kontainer-driver-metadata/release-v2.11/data.json | jq -r '.K8sVersionRKESystemImages | keys'
variable "rke1_version" {
  type        = string
  description = "Version of rke1 to install."
  default     = "v1.28.12-rancher1-1"
}

variable "network_plugin" {
  type        = string
  description = "Network plugin to be used"
  default     = ""
}

# ----------------------------------------------------------------------
# USERS
# ----------------------------------------------------------------------

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

variable "argocd_kubernetes_url" {
  type        = string
  description = "URL to kubernetes cluster (leave blank to use same as rancher)"
  default     = ""
}

variable "argocd_kubernetes_token" {
  type        = string
  sensitive   = true
  description = "Access token for kubernetes cluster"
  default     = ""
}

# ----------------------------------------------------------------------
# APPLICATIONS
# ----------------------------------------------------------------------

variable "monitoring_enabled" {
  type        = bool
  description = "Enable monitoring in rancher"
  default     = true
}

variable "cinder_enabled" {
  type        = bool
  description = "Enable cinder storage"
  default     = true
}

variable "manila_nfs_enabled" {
  type        = bool
  description = "Enable manila nfs storage"
  default     = false
}

variable "manila_cephfs_enabled" {
  type        = bool
  description = "Enable manila cephfs storage"
  default     = false
}

variable "manila_cephfs_type" {
  type        = string
  description = "Manila cephfs type"
  default     = "default"
}

variable "longhorn_enabled" {
  type        = bool
  description = "Enable longhorn storage"
  default     = false
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

variable "healthmonitor_enabled" {
  type        = bool
  description = "Enable healthmonitor"
  default     = false
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
  default     = true
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
