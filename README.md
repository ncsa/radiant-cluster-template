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

In the terraform folder are the scripts that you can use to start a new cluster using terraform. You need to edit the file terraform.tfvars to fit your need. You can check-in this file, it is recomended to store any secrets in a file called `secrets.auto.tfvars`, this file is already ignored.

Once you have setup your variables, you will need to initialize terraform:

```bash
terraform init
```

To update the modules that come from github, you need to delete them before you fetch them:

```bash
rm -rf .terraform/modules/{argocd,openstack_cluster,rancher_cluster}
terraform init
```

## Shared State

If you want to change where the state is written you will can add a file called `backend.tf`. This file can contain the specific setup where to store the shared state. For example when using gitlab to store the state you can create the following file, see also [gitlab documentation](https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html) for more info.

```hcl
terraform {
  backend "http" {
  }
}
```

Next you need to initialze and configure the backend, the password can be generated in gitlab. If you want to use the project token you will need to make sure it has read/write to the repository to allow to store the state.
```bash
PROJECT_BASE_URL="https://git.ncsa.illinois.edu" \
PROJECT_ID=699 \
NAME="kubernetes" \
PROJECT_USERNAME="terraform" \
PROJECT_PASSWORD="supersecret" ; \
terraform init \
  -backend-config="address=https://git.example.com/api/v4/projects/${PROJECT_ID}/terraform/state/${CLUSTER}" \
  -backend-config="lock_address=https://git.example.com/api/v4/projects/${PROJECT_ID}/terraform/state/${CLUSTER}/lock" \
  -backend-config="unlock_address=https://git.example.com/api/v4/projects/${PROJECT_ID}/terraform/state/${CLUSTER}/lock" \
  -backend-config="username=${PROJECT_USERNAME}" \
  -backend-config="password=${PROJECT_PASSWORD}" \
  -backend-config="lock_method=POST" \
  -backend-config="unlock_method=DELETE" \
  -backend-config="retry_wait_min=5"
```

## GitLab Pipelines

You can setup a gitlab runner to automatically apply any changes you make to the git repo and update the cluster, for example to add/remove worker nodes. You can leverage of the ability to store variables at the project and group level. For example you can have a group where you keep all your clusters and use this for shared secrets, and have per project secrets for each git repo.  The variables will need to be called `TF_VAR_<variable-name>`. 

Copy the [example](gitlab-ci.yml) of the gitlab runner to .gitlab-ci.yml

## Hints

To get the versions for RKE2 you can run the following from the command line:

```bash
curl -s https://api.github.com/repos/rancher/rke2/releases | jq '.[] | select(.prerelease == false) | .name'
```
