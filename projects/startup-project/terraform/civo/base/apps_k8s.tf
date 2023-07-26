# Create a cluster without specific cluster type by default is k3s
resource "civo_kubernetes_cluster" "apps" {
    name = "apps"
    applications = ""
    firewall_id = civo_firewall.apps_k8s_cp.id
    network_id = civo_network.apps.id
    cluster_type = "k3s"
    tags = "apps"
    pools {
        label = "apps"
        size = "g3.k3s.medium"
        node_count = 3
    }
}
