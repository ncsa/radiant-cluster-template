# Kubernetes cluster bootstrapping template

This is mirrored to GitHub, the code can be found at: https://git.ncsa.illinois.edu/kubernetes/radiant-cluster-template

This repo contains a template to bootstrap a Kubernetes cluster hosted on an OpenStack platform. It is specifically designed for use with OpenStack-based cloud computing platforms Radiant (NCSA) and Jetstream2 (Indiana University); however, it should be flexible enough to target any OpenStack instance.

## Initialize your project Git repo from the template

Your cluster's private repo needs to be hosted on a service that supports Terraform state version control such as GitLab. The `$CLUSTER_GIT_REPO` environment variable below will typically be of the form

```bash
CLUSTER_GIT_REPO="git@gitlab.com:${CLUSTER_PROJECT}/${CLUSTER_NAME}.git"
```

Thus if you name your cluster `cuddlefish` and your research project is `marine-biology`, and you host your repo on `gitlab.com`, then your Git repo could be `git@gitlab.com:marine-biology/cuddlefish.git`.

To get started, clone this repository, rename the remote, and attach to a new origin. This will allow you to pull in the latest template changes, and push them to your own private repository.

```bash
git clone git@github.com:ncsa/radiant-cluster-template.git $CLUSTER_NAME
cd $CLUSTER_NAME
git remote rename origin template
git remote set-url --push template no_push
git remote add origin $CLUSTER_GIT_REPO
git push -u origin --all
git push -u origin --tags
```

To update from template repository

```bash
git fetch template
git merge template/main
git push
```

## Customize cluster configuration files

In the `terraform` folder are the scripts that you can use to start a new cluster using Terraform. First, you need to customize and prepare some files:

- `terraform.tfvars` : Customize to override default values for supported parameters as needed. Do not include secrets in this file; it should be save to commit.

- Copy `cluster.example.json` to `cluster.json` and customize to define your cluster nodes.


## Obtain OpenStack application credentials and Rancher token

Open the OpenStack Horizon web interface and navigate to **Identity -> Application Credentials** and create a new one for use by Terraform. Set the Terraform variables as shown below in `terraform/secrets.auto.tfvars`. (All `*.auto.tfvars` files are included in `.gitignore` to avoid uploading secrets to your remote repo.)

```
openstack_credential_id     = "f5****28"
openstack_credential_secret = "b2**************Vw"
```

From the Rancher web interface, navigate to **Account and API Keys** and create an API key, copying the value into the same secrets file like so:

```
rancher_token                 = "token-wmrk9:nb************c2"
```

## Update Terraform modules (optional)

If you have previously initialized the Terraform state and want to update the Terraform modules, you must delete them prior to executing `terraform init` as described below:

```bash
cd terraform
rm -rf .terraform/modules/{argocd,openstack_cluster,rancher_cluster}
```

## Initialize the Terraform state

To download the Terraform modules and initialize the Terraform state you have two options: (1) Operate completely locally or (2) configure a backend to push state updates to a remote location. Configuring a remote backend is recommended when collaborating with others, because it provides shared access and a mechanism for state locking to prevent accidental conflicting updates.

(Note that if you have already initialized a Terraform repo, subsequent initialization commands need the `terraform init -reconfigure` option.)

### Local state only

```bash
cd terraform
terraform init
```

### Use a remote backend (optional)

Create a file called `backend.tf` with the content below See [GitLab documentation](https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html) and [Terraform docs](https://developer.hashicorp.com/terraform/language/settings/backends/http) for more info.

```hcl
terraform {
  backend "http" {
  }
}
```

Next you need to initialize and configure the backend. Generate a new GitLab project access token via the GitLab web UI and assign to `PROJECT_PASSWORD`. The token must be granted role `Maintainer` with scopes `api`, `read_repository` and `write_repository` to allow Terraform state storage. The `PROJECT_ID` can be found in the Settings > General page of the target repo in GitLab.


```bash
PROJECT_BASE_URL="https://git.ncsa.illinois.edu" \
PROJECT_ID=123 \
CLUSTER_NAME="kubernetes" \
PROJECT_USERNAME="access_token_name" \
PROJECT_PASSWORD="access_token_value" ; \
terraform init \
  -backend-config="address=${PROJECT_BASE_URL}/api/v4/projects/${PROJECT_ID}/terraform/state/${CLUSTER_NAME}" \
  -backend-config="lock_address=${PROJECT_BASE_URL}/api/v4/projects/${PROJECT_ID}/terraform/state/${CLUSTER_NAME}/lock" \
  -backend-config="unlock_address=${PROJECT_BASE_URL}/api/v4/projects/${PROJECT_ID}/terraform/state/${CLUSTER_NAME}/lock" \
  -backend-config="username=${PROJECT_USERNAME}" \
  -backend-config="password=${PROJECT_PASSWORD}" \
  -backend-config="lock_method=POST" \
  -backend-config="unlock_method=DELETE" \
  -backend-config="retry_wait_min=5"
```

## Run Terraform plan and apply

⚠ If you have used the OpenStack CLI in your shell session, ensure that the associated environment variables are unset or you will see errors when executing `terraform plan`.

```bash
unset $(set | grep -o "^OS_[A-Za-z0-9_]*")
```


## ArgoCD Applications

The folder `charts` can contain Helm charts that are referenced from the root app. An convenience app is placed there called `kubernetes`. This application will deploy all files in the `kubernetes` folder by default. To enable this process set `kubernetes.enabled` to true in `values.yaml`. You can add more applications to this Helm chart, as well as the specific values to the `values.yaml` file to setup your cluster. If this git repo requires authentication you can configure a [git repo](examples/gitrepo.yaml) in the ArgoCD folder (see below).

## GitLab Pipelines

You can setup a GitLab runner to automatically apply any changes you make to the git repo and update the cluster, for example to add/remove worker nodes. You can leverage of the ability to store variables at the project and group level. For example you can have a group where you keep all your clusters and use this for shared secrets, and have per project secrets for each git repo.  The variables will need to be called `TF_VAR_<variable-name>`. 

Copy the [example](examples/gitlab-ci.yml) of the GitLab runner to `.gitlab-ci.yml`

### ArgoCD

You can create a folder called `argocd` and place the files to be applied to the ArgoCD cluster. The pipeline will check during the `deploy` stage to see if the folder exists, and if it does, it applies the files to the ArgoCD cluster. This is a convenient way to get [git repo](examples/gitrepo.yaml) defined (using sealed secrets off course) as well as the [root app](examples/apps.yaml) for the cluster.

