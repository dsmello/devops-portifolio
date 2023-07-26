data "civo_network" "devops" {
    label = "devops"
}

data "civo_network" "apps" {
    label = "apps"
}

data "civo_reserved_ip" "devops_lb" {
    name = "devops-lb"
}

data "civo_reserved_ip" "apps_lb" {
    name = "apps-lb"
}

data "civo_firewall" "devops_k8s_lb" {
    name = "devops-k8s-lb"
}

data "civo_firewall" "apps_k8s_lb" {
    name = "apps-k8s-lb"
}

data "civo_kubernetes_cluster" "devops" {
    name = "devops-tools"
}

data "civo_kubernetes_cluster" "apps" {
    name = "apps"
}