resource "helm_release" "devops-argo-cd" {
  provider = helm.helmdevops

  name       = "devops-argocd"
  namespace = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"

  create_namespace = true

  set {
      name  = "service.type"
      value = "ClusterIP"
  }

  description = "The main CD tool for the DevOps Cluster"

}

# Argocd : Github Credentials
resource "kubernetes_secret_v1" "argocd-project-github-cred" {
  provider = kubernetes.kubedevops

  depends_on = [ helm_release.devops-argo-cd ]
  metadata {
    name = "argocd-github-cred"
    namespace = helm_release.devops-argo-cd.namespace
    labels = {
        "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  data = {
    type = "git"
    url = "https://github.com/${var.github_user}"
    username = var.github_user
    password = var.github_token
  }

  lifecycle {
    ignore_changes = [
        data
    ]
  }
}

# Argocd : Apps Cluster Credentials
resource "kubernetes_secret_v1" "argocd-project-apps-cluster-cred" {
  provider = kubernetes.kubedevops

  depends_on = [ helm_release.devops-argo-cd ]
  metadata {
    name = "apps-cluster-creddentials"
    namespace = helm_release.devops-argo-cd.namespace
    labels = {
        "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name = "apps-cluster"
    server = module.kubeconfig_apps.host
    config = jsonencode({
      tlsClientConfig = {
        caData = module.kubeconfig_apps.certificate_authority_data_b64
        certData = module.kubeconfig_apps.client_certificate_data_b64
        keyData =  module.kubeconfig_apps.client_key_data_b64
        # serverName = module.kubeconfig_apps.host
        insecure = true
      }
    })
  }
}
