
# Terraform
## Cloud
cloud_init:
	@echo "Initializing Terraform - Cloud"
	@cd terraform/civo/base && \
	terraform init -backend-config=$${TF_BACKEND_CONFIG}

cloud_plan:
	@echo "Planning Terraform - Cloud"
	@cd terraform/civo/base && \
	terraform plan -var-file=./vars/prd.tfvars

cloud_apply:
	@echo "Applying Terraform - Cloud"
	@cd terraform/civo/base && \
	terraform apply -var-file=./vars/prd.tfvars

cloud_destroy:
	@echo "Destroying Terraform - Cloud"
	@cd terraform/civo/base && \
	terraform apply -var-file=./vars/prd.tfvars --destroy

## K8s Cluster

k8s_init:
	@echo "Initializing Terraform - K8s Cluster"
	@cd terraform/k8s && \
	terraform init -backend-config=$${TF_BACKEND_CONFIG}

k8s_plan:
	@echo "Planning Terraform - K8s Cluster"
	@cd terraform/k8s && \
	terraform plan -var-file=./vars/prd.tfvars

k8s_apply:
	@echo "Applying Terraform - K8s Cluster"
	@cd terraform/k8s && \
	terraform apply -var-file=./vars/prd.tfvars

k8s_destroy:
	@echo "Destroying Terraform - K8s Cluster"
	@cd terraform/k8s && \
	terraform apply -var-file=./vars/prd.tfvars --destroy

## K8s Cluster Manifests

manifests_init:
	@echo "Initializing Terraform - K8s Cluster Manifests"
	@cd terraform/k8s_manifests && \
	terraform init -backend-config=$${TF_BACKEND_CONFIG}

manifests_plan:
	@echo "Planning Terraform - K8s Cluster Manifests"
	@cd terraform/k8s_manifests && \
	terraform plan -var-file=./vars/prd.tfvars

manifests_apply:
	@echo "Applying Terraform - K8s Cluster Manifests"
	@cd terraform/k8s_manifests && \
	terraform apply -var-file=./vars/prd.tfvars

manifests_destroy:
	@echo "Destroying Terraform - K8s Cluster Manifests"
	@cd terraform/k8s_manifests && \
	terraform apply -var-file=./vars/prd.tfvars --destroy

