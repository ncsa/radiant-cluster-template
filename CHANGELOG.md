# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this project adheres to [Semantic Versioning](http://semver.org/).


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
