# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

## 3.5.0 - 2025-07-15

### Added
- added option `rke2_cis_hardening` (default false) to install RKE2 security options for CIS Benchmark compliance
  - add etcd user/group
  - configure kernel params for CIS benchmark
  - add option for RKE2 CIS profile if `rke2_cis_hardening` enabled
- added option to define pod security admission (PSA) template

### Changed
- define machine labels as map(string), not array of key=value strings

## 3.4.0 - 2025-05-05

### Changed
- changed the data structure in variables that holds the machine definition

## 3.3.0 - 2025-05-04

## Added
- Qualys Agent install

## Changed
- Updated README

## 3.2.1 - 2024-08-30

## Fixed
- IP address for rancher changed
- traefik expose parameter changed

## 3.2.0 - 2024-08-15

Since the code can now creaet RKE2 and K3S clusters, the branch rke1 is no longer used and all code is merged into main.
In version 4.0.0 I will remove the ability to create RKE1 clusters.

## Added
- Ability to now create RKE2/K3S clusters

## 3.1.0 - 2024-06-09

This has now been tested with jetstream2 and should be able to create a cluster on jetstream2.

## Added

- Added configuration for manila-nfs and manila-cephs
- Can set region from default
- Can set os images

## 3.0.0 - 2024-02-21

Removed all deprecated code. Clusters should now be defined using cluster.json.

### Changed
- argocd_app is no longer used, all apps installed using argocd
- add custom rules to firewall for ports opened in traefik
- defaults changed for the following variables
  - cinder is now enabled by default
  - longhorn is now disabled by default
  - healthmonitor is now disabled by default
  - sealedsecrets is now enabled by default

### Added
- ability to set network. Default is weave to be compatible with previous version but this should be changed. Weave is EOL 12/31/2024
  - canal (rancher default)
  - calico
  - flannel
  - weave (deprecated)
  - none

## 2.1.1 - 2023-09-06

### Changed
- Expose IP security group for kube api (defaults to rancher)
- Expose IP security group for ssh (defaults to NCSA)

## 2.1.0 - 2023-08-03

In the next major update all backwards compatible code will be removed. Please migrate to teh cluster_machine setup and set controlplane_count and worker_count to 0

### Changed
- This add backwards compatibility to the stack, you still need ot define the cluster machines

## 2.0.0 - 2023-06-28

This is based on radiant-cluster version 2. This changes the way cluster is defined and now uses a json file to define the cluster. This will allow you to have different types of worker nodes:

```json
{
  "machines": [
    {
      "name": "controlplane",
      "role": "controlplane",
      "count": 3,
      "flavor": "gp.medium",
      "os": "ubuntu"
    },
    {
      "name": "worker",
      "count": 3,
      "flavor": "gp.large",
      "disk": 40,
      "os": "ubuntu"
    }
  ]
}
```

### Changed

- radiant users are no longer added as admins
- all openstack variables have been removed

## 1.0.2 - 2023-01-31

### Added
- security group now can set ip address of kube api as a variable.

### Changed
- disabled monitoring in argocd it never synchronizes

## 1.0.1 - 2022-10-24

### Changed
- monitoring is now managed in argocd, this will make it such that the latest version will be installed/upgraded

### Removed
- removed the argocd-master flag, now all clusters are assumed to be external, including where argocd runs

## 1.0.0 - 2022-10-24

### Added
- added this Changelog
- added github workflow to create releases

### Changed
- compute nodes in rke1 now set availability zone (default nova), availabilty zone is ignored for existing nodes.
