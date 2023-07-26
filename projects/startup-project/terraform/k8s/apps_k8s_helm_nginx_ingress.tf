locals {
  apps_nginx_ingress_values = {
    controller = {
      service = {
        annotations = {
          "kubernetes.civo.com/firewall-id" = data.civo_firewall.apps_k8s_lb.id
          "kubernetes.civo.com/ipv4-address" = data.civo_reserved_ip.apps_lb.ip
        }
      }
    }
  }
}

resource "helm_release" "apps-nginx-ingress" {
  provider = helm.helmapps

  name       = "nginx-ingress"
  namespace = "ingress"
  repository = "oci://ghcr.io/nginxinc/charts"
  chart = "nginx-ingress"
  version = "0.18.0"

  create_namespace = true

  values = [yamlencode(local.apps_nginx_ingress_values)]

  description = "The main Ingress Controller for the Apps Cluster"


}
