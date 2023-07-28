locals {
  namespace_argocd = "argocd"
}

# Will use App of Apps pattern to deploy ArgoCD projects
resource "kubernetes_manifest" "argocd-project" {
  provider = kubernetes.kubedevops

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "AppProject" 
    metadata = {
      name = "devops-tools"
      namespace = local.namespace_argocd
    }
    spec = {
        description = "The 'App' of Apps used to deploy all other applications at the DevOps Cluster"
        sourceRepos = [ "*" ]
        destinations = [
            {
                namespace = "*"
                server = "*"
            }
        ]
        clusterResourceWhitelist = [
          {
              group = "*"
              kind = "*"
          }
      ]
      namespaceResourceWhitelist = [
          {
              group = "*"
              kind = "*"
          }
      ]
    }
  }
}

# ArgoCD : Application

resource "kubernetes_manifest" "argocd-project-app" {
  provider = kubernetes.kubedevops
  depends_on = [ kubernetes_manifest.argocd-project ]

  manifest = {
      apiVersion = "argoproj.io/v1alpha1"
      kind = "Application"
      metadata = {
          name = "devops-tools"
          namespace = local.namespace_argocd
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