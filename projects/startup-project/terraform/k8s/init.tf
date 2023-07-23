

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

resource "local_sensitive_file" "devops_kubeconfig" {
  content  = data.civo_kubernetes_cluster.devops.kubeconfig
  filename = local.devops_kubeconfig_path
}

resource "local_sensitive_file" "apps_kubeconfig" {
  content  = data.civo_kubernetes_cluster.apps.kubeconfig
  filename = local.apps_kubeconfig_path
}

# The Kubernetes Clusters

provider "kubernetes" {
  alias = "kubedevops"
  config_path = local_sensitive_file.devops_kubeconfig.filename

}

provider "kubernetes" {
  alias = "kubeapps"
  config_path =  local_sensitive_file.apps_kubeconfig.filename
}

provider "helm" {
  alias = "helmdevops"
  kubernetes {
    config_path = local_sensitive_file.devops_kubeconfig.filename 
  }
}

provider "helm" {
  alias = "helmapps"
  kubernetes {
    config_path = local_sensitive_file.apps_kubeconfig.filename
  }
}
