output "host" {
    description = "value of the host"
    value = local.kubeconfig.clusters[0].cluster.server
    sensitive = true
}

output "name" {
    description = "value of the name"
    value = local.kubeconfig.clusters[0].name
}

output "certificate_authority_data" {
    description = "value of the certificate_authority_data"
    value = base64decode(local.kubeconfig.clusters[0].cluster.certificate-authority-data)
    sensitive = true
}

output "certificate_authority_data_b64" {
    description = "value of the certificate_authority_data"
    value = local.kubeconfig.clusters[0].cluster.certificate-authority-data
    sensitive = true
}

output "client_certificate_data" {
    description = "value of the client_certificate_data"
    value = base64decode(local.kubeconfig.users[0].user.client-certificate-data)
    sensitive = true
}

output "client_certificate_data_b64" {
    description = "value of the client_certificate_data"
    value = local.kubeconfig.users[0].user.client-certificate-data
    sensitive = true
}

output "client_key_data" {
    description = "value of the client_key_data"
    value = base64decode(local.kubeconfig.users[0].user.client-key-data)
    sensitive = true
}

output "client_key_data_b64" {
    description = "value of the client_key_data"
    value = local.kubeconfig.users[0].user.client-key-data
    sensitive = true
}