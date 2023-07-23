resource "civo_network" "apps" {
    label = "apps"
}

resource "civo_reserved_ip" "apps_lb" {
    name = "apps-lb"
}

// The following rules are for the K8s API server
resource "civo_firewall" "apps_k8s_cp" {
    name = "apps-k8s-cp"
    network_id = civo_network.apps.id
    create_default_rules = false

    ingress_rule {
        action = "allow"
        cidr = [var.operator_ip]
        label = "Operator IP to access the Kubernetes API server"
        protocol = "tcp"
        port_range = "6443"
    }

    ingress_rule {
        action = "allow"
        cidr = ["${civo_kubernetes_cluster.devops.master_ip}/32"]
        label = "The devops cluster to access the Kubernetes API server, Used for the ArgoCD"
        protocol = "tcp"
        port_range = "6443"
    }

    egress_rule {
        action = "allow"
        cidr = ["0.0.0.0/0"]
        protocol = "tcp"
        port_range = "1-65535"
    }
}

// The following rules are for the load balancer
// With allows the HTTP and HTTPS traffic to the load balancer.
resource "civo_firewall" "apps_k8s_lb" {
    name = "apps-k8s-lb"
    network_id = civo_network.devops.id
    create_default_rules = false

    ingress_rule {
        action = "allow"
        cidr = ["0.0.0.0/0"]
        label = "http"
        protocol = "tcp"
        port_range = "80"
    }

    ingress_rule {
        action = "allow"
        cidr = ["0.0.0.0/0"]
        label = "https"
        protocol = "tcp"
        port_range = "443"
    }

}

