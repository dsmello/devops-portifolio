# The Startup Project

This is a demo project to show how to create an infrastructure at the CIVO Cloud using Terraform. And a small devops tooling to manage the infrastructure with and app deployment.

[TLTR](#TLTR)

## The Company:

This is a small startup with after some considerations, they saw their used case wasnt good fit for paas. So they decided to use IaaS. The company has a small team of developers and a small team of devops. The company has a small budget, so they need to use the best cost/benefit solution.

They want to have the entire infrastructure as code, and they want to use the GitOps methodology to manage the infrastructure. They want to have a CI/CD pipeline to deploy their apps. They want to have a SRE to monitor the infrastructure. They want to have a networking solution to manage the traffic between the apps and the internet. They want to have a solution to manage the access to the infrastructure.

And they want to have all of this with the smallest impact on the developer experience.

The company has are using the Github as their code repository. And they are using the Github Actions as their CI/CD pipeline.

After some discussions, the company decided to use the Civo Cloud as their cloud provider. Beccause is close to their user base, and is easy to forsee the costs.


## The Goals:

- Create the entire infrastructure using Terraform
- Enable the GitOps using ArgoCD
- Create the CI/CD pipelines using Github Actions
- Enable the SRE using Prometheus, Grafana, Loki, Alertmanager, Vitoriametrics, Promtail and Node Exporter
- Enable the networking using Nginx Ingress, Linkerd and Teleport
- Must be easy to the company developers to deploy their apps, and access the infrastructure
- The entire stack must be non vendor lock-in

## Considerations:

- Because the project is for a small startup, some non critical apps wont be deployed as HA
- This entire project is thinked to be managed by a single person.
- The project is thinked to be deployed in a single region.
- The project is thinked to be deployed in a single cloud provider.
- All the choices are made thinking in the simplicity and the cost.

## The project structure

The project is divided in two parts: the first one is the "Cloud" and the second one is the "DevOps" Tooling.

### The Cloud

The Civo cloud is a cloud provider focused in simplicity. And because of that some feature are out of the user reach. So we must use some workarounds to archive our goals.

![The Cloud](./docs/imgs/devops_portifolio_civo_cloud.png)

The general idea here is:

- Network:
    - Devops
    - Apps
- Firewall:
    - Devops Tools K8s
    - Devops Tools Control Plane
    - Apps K8s
    - Apps Control Plane
- Static IP:
    - Devops LB
    - Apps LB
- Kubernetes:
    - Devops Tools
    - Apps

## The implementation

Because this is the first project, we'll create an object storage to store the terraform state.

Because the Civo has support to Terraform and allow us to retrive the kubeconfig, we can use the Terraform to create the entire infrastructure.

The project will have two parts: the first one is the terraform creations and the second one is the argocd creations.

Look at the [terraform](./terraform/) folder to see the code. And look at the [argocd](./k8s/main/) folder to see the code.

# TLTR

## Requirements:

- Terraform
- CIVO Cloud account
- Github account

## How to use:
