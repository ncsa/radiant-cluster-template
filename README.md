This is a template to get you started setting up a cluster in radiant at NCSA

# Git Setup

To get started, clone this repository, rename the remote, and attach to a new origin. This will allow you to pull in the latest changes from GitHub, and push them to your own private repository.

```bash
git clone git@github.com:ncsa/radiant-cluster-template.git <clustername>
cd <clustername>
git remote rename origin template
git remote set-url --push template no_push
git remote add origin git@git.example.com:clustername.git
git push -u origin --all
git push -u origin --tags
```

To update from template repository

```bash
git fetch template
git merge template/main
git push
```

# TERRAFORM

In the terraform folder are the scripts that you can use to start a new cluster using terraform. You need to edit the file terraform.tfvars to fit your need.

If you want to change where the state is written you will need to update versions.tf. For example to use gitlab you will use:

```hcl
terraform {
  backend "http" {
  }
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
  }
}
```

Once you are ready, you will need to initialize terraform using
```bash
terraform init
```

or if you enabled the remote backend you can use:
```bash
PROJECT_BASE_URL="git.example.com" \
PROJECT_ID=699 \
CLUSTER="myname" \
PROJECT_USERNAME="whome" \
PROJECT_PASSWORD="supersecret" \
terraform init \
  -backend-config="address=https://${PROJECT_BASE_URL}/api/v4/projects/${PROJECT_ID}/terraform/state/${CLUSTER}" \
  -backend-config="lock_address=https://${PROJECT_BASE_URL}/api/v4/projects/${PROJECT_ID}/terraform/state/${CLUSTER}/lock" \
  -backend-config="unlock_address=https://${PROJECT_BASE_URL}/api/v4/projects/${PROJECT_ID}/terraform/state/${CLUSTER}/lock" \
  -backend-config="username=${PROJECT_USERNAME}" \
  -backend-config="password=${PROJECT_PASSWORD}" \
  -backend-config="lock_method=POST" \
  -backend-config="unlock_method=DELETE" \
  -backend-config="retry_wait_min=5"
```

For more info see the [gitlab documentation](https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html).

To get the versions for RKE2 you can run the following from the command line:

```bash
curl -s https://api.github.com/repos/rancher/rke2/releases | jq '.[] | select(.prerelease == false) | .name'
```

