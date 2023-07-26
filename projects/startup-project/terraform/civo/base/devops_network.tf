resource "civo_network" "devops" {
    label = "devops"
}

resource "civo_reserved_ip" "devops_lb" {
    name = "devops-lb"
}

// The following rules are for the K8s API server
resource "civo_firewall" "devops_k8s_cp" {
    name = "devops-k8s-cp"
    network_id = civo_network.devops.id
    create_default_rules = false

    ingress_rule {
        action = "allow"
        cidr = [var.operator_ip]
        label = "Operator IP to access the Kubernetes API server"
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
// With allows the HTTP and HTTPS traffic to the load balancer, and the default ports of the Teleport Server
resource "civo_firewall" "devops_k8s_lb" {
    name = "devops-k8s-lb"
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
    
    ingress_rule {
        action = "allow"
        cidr = ["0.0.0.0/0"]
        protocol = "tcp"
        port_range = "3023"
        label = "sshproxy"
    }

    ingress_rule {
        action = "allow"
        cidr = ["0.0.0.0/0"]
        protocol = "tcp"
        port_range = "3024"
        label = "sshtun"
    }

    ingress_rule {
        action = "allow"
        cidr = ["0.0.0.0/0"]
        protocol = "tcp"
        port_range = "3026"
        label = "k8s"
    }

    ingress_rule {
        action = "allow"
        cidr = ["0.0.0.0/0"]
        protocol = "tcp"
        port_range = "3036"
        label = "mysql"
    }

}

