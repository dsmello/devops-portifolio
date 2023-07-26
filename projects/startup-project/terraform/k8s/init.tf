

terraform {
  backend "s3" {
    endpoint                    = "https://objectstore.fra1.civo.com"
    bucket                      = "terraform-states"
    key                         = "kubernetes/terraform.tfstate"
    region                      = "fra1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }

  required_providers {
    civo = {
      source = "civo/civo"
      version = "1.0.35"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.22.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.10.1"
    }

    local = {
      source = "hashicorp/local"
      version = "2.4.0"
    }

  }
}

# The Cloud Provider
provider "civo" {
  # Configuration options 
  token = var.civo_api_key
  region = "fra1"
}


# Write the kubeconfig files to the local disk
provider "local" {
}

locals {
  temp_dir = "${path.root}/.terraform/tmp"
  devops_kubeconfig_path = "${local.temp_dir}/kube.devops.tmp"
  apps_kubeconfig_path = "${local.temp_dir}/kube.apps.tmp"
}

module "kubeconfig_devops" {
  source = "../../../../terraform_modules/civo/kubeconfig"
  kubeconfig_string = data.civo_kubernetes_cluster.devops.kubeconfig
}

module "kubeconfig_apps" {
  source = "../../../../terraform_modules/civo/kubeconfig"
  kubeconfig_string = data.civo_kubernetes_cluster.apps.kubeconfig
}

# The Kubernetes Clusters

provider "kubernetes" {
  alias = "kubedevops"
  host = module.kubeconfig_devops.host
  cluster_ca_certificate = module.kubeconfig_devops.certificate_authority_data
  client_certificate = module.kubeconfig_devops.client_certificate_data
  client_key = module.kubeconfig_devops.client_key_data
}

provider "kubernetes" {
  alias = "kubeapps"
  host = module.kubeconfig_apps.host
  cluster_ca_certificate = module.kubeconfig_apps.certificate_authority_data
  client_certificate = module.kubeconfig_apps.client_certificate_data
  client_key = module.kubeconfig_apps.client_key_data
}

provider "helm" {
  alias = "helmdevops"
  kubernetes {
    host = module.kubeconfig_devops.host
    cluster_ca_certificate = module.kubeconfig_devops.certificate_authority_data
    client_certificate = module.kubeconfig_devops.client_certificate_data
    client_key = module.kubeconfig_devops.client_key_data
  }
}

provider "helm" {
  alias = "helmapps"
  kubernetes {
    host = module.kubeconfig_apps.host
    cluster_ca_certificate = module.kubeconfig_apps.certificate_authority_data
    client_certificate = module.kubeconfig_apps.client_certificate_data
    client_key = module.kubeconfig_apps.client_key_data
  }

}
