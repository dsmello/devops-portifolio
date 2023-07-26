// This module decode the kubeconfig yaml string and return as output the kubeconfig file

locals {
    kubeconfig = yamldecode(var.kubeconfig_string)
}