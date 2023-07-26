# Cloud: Civo
variable "civo_api_key" {
    type = string
    description = "The Civo cloud API key"
}

# Tools: Terraform


# Project

variable "project" {
    type = string
    description = "The Civo cloud API key"
}

variable "env" {
    type = string
    description = "The Civo cloud API key"
}

variable "operator_ip" {
    type = string
    description = "The user's IP address"
    default = ""
}

# Github
variable "github_user" {
    type = string
    description = "The Github user"
    default = "dsmello"
}
