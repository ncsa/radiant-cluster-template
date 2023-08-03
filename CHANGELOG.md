# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).

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
