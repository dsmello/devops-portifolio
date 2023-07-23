# Create a cluster without specific cluster type by default is k3s
resource "civo_kubernetes_cluster" "devops" {
    name = "devops-tools"
    applications = ""
    firewall_id = civo_firewall.devops_k8s_cp.id
    network_id = civo_network.devops.id
    cluster_type = "k3s"
    tags = "devops-tools"
    pools {
        label = "devops-tools" // Optional
        size = "g3.k3s.medium"
        node_count = 3
    }
}
