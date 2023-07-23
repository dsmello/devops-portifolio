resource "helm_release" "devops-argo-cd" {
   provider = helm.helmdevops

  provisioner "file" {
    source = local_sensitive_file.devops_kubeconfig.filename
    destination = "${local.devops_kubeconfig_path}.tmp"
    when = create
  }

  name       = "devops-argocd"
  namespace = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"

  create_namespace = true

  set {
      name  = "service.type"
      value = "ClusterIP"
  }

}

# Will use App of Apps pattern to deploy ArgoCD projects
resource "kubernetes_manifest" "argocd-project" {
  provider = kubernetes.kubedevops

  depends_on = [ helm_release.devops-argo-cd ]
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "AppProject"
    metadata = {
        name = "devops-tools"
        namespace = helm_release.devops-argo-cd.namespace
    }
    spec = {
        description = "The 'App' of Apps used to deploy all other applications"
        sourceRepos = [ "*" ]
        destinations = [
            {
                namespace = "*"
                server = "https://kubernetes.default.svc"
            }
        ]
        clusterResourceWhitelist = [
          {
              group = "*"
              kind = "*"
          }
      ]
    }
  }
}

# Argocd : Github Credentials
resource "kubernetes_secret_v1" "argocd-project-github-cred" {
  provider = kubernetes.kubedevops
  provisioner "file" {
    source = local_sensitive_file.devops_kubeconfig.filename
    destination = "${local.devops_kubeconfig_path}.tmp"
    when = create
  }
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

# ArgoCD : Application

resource "kubernetes_manifest" "argocd-project-app" {
  provider = kubernetes.kubedevops
  depends_on = [ helm_release.devops-argo-cd ]
  manifest = {
      apiVersion = "argoproj.io/v1alpha1"
      kind = "Application"
      metadata = {
          name = "devops-tools"
          namespace = helm_release.devops-argo-cd.namespace
      }
      spec = {
          project = "devops-tools"
          source = {
              repoURL = "https://github.com/${var.github_user}/devops-portifolio"
              targetRevision = "HEAD"
              path = "projects/startup-project/k8s/main"
          }
          destination = {
              server = "https://kubernetes.default.svc"
              namespace = "default"
          }
      }
  }
}