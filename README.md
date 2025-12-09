# rke2-lab

This project provides an infrastructure-as-code (IaC) lab environment for deploying and managing [RKE2](https://docs.rke2.io/) (Rancher Kubernetes Engine 2) clusters using [Terraform](https://www.terraform.io/) and [libvirt](https://libvirt.org/). It is designed for testing, development, and production-like simulations on local or remote virtualization platforms.

## Features
- Modular Terraform code for reusable infrastructure components
- Support for multiple environments (e.g., `test`, `prod`)
- Automated provisioning of VMs and RKE2 clusters
- Example configuration files for easy customization
- State management with remote or local backends

## Project Structure
```
├── environments/
│   ├── prod/
│   │   ├── backend.tf         # Backend configuration for production state
│   │   └── main.tf           # Main Terraform file for production
│   └── test/
│       ├── backend.tf        # Backend configuration for test state
│       ├── config.yaml       # Example configuration for test environment
│       ├── config.yaml.example
│       ├── main.tf           # Main Terraform file for test
│       └── states/           # Terraform state files
│           ├── terraform.tfstate
│           └── terraform.tfstate.backup
├── modules/
│   ├── libvirt/              # Libvirt VM provisioning module
│   │   ├── domain.tf
│   │   ├── main.tf
│   │   ├── storage.tf
│   │   ├── variables.tf
│   │   ├── versions.tf
│   │   └── templates/
│   │       ├── meta_data.yaml
│   │       ├── network_config.yaml
│   │       └── user_data.yaml
│   ├── rke2/                 # RKE2 cluster provisioning module
│   │   ├── main.tf
│   │   └── versions.tf
│   └── kube/                 # Kubernetes management module
│       ├── certificates.tf
│       ├── charts.tf
│       ├── main.tf
│       ├── metallb.tf
│       ├── namespaces.tf
│       ├── variables.tf
│       ├── versions.tf
│       └── virtual_services.tf
└── README.md
```

## Prerequisites
- [Terraform](https://www.terraform.io/) 
- [libvirt](https://libvirt.org/) and [virt-install](https://virt-manager.org/)
- [qemu-kvm](https://www.qemu.org/)
- [RKE2](https://docs.rke2.io/)
- Linux host with virtualization support

## Getting Started
1. **Clone the repository:**
	```bash
	git clone <this-repo-url>
	cd rke2-lab
	```
2. **Configure your environment:**
	- Copy and edit the example config if needed:
	  ```bash
	  cp environments/test/config.yaml.example environments/test/config.yaml
	  # Edit environments/test/config.yaml as needed
	  ```
3. **Initialize Terraform:**
	```bash
	cd environments/test
	terraform init
	```
4. **Apply the infrastructure:**
	```bash
	terraform apply
	# Or to destroy:
	terraform destroy
	```

## Environments
- `environments/test`: For development and testing. Uses local state by default.
- `environments/prod`: For production-like deployments. Configure `backend.tf` for remote state if needed.

## Modules
- `modules/libvirt`: Handles VM creation, storage, and networking using libvirt.
- `modules/rke2`: Provisions and configures RKE2 clusters on the created VMs.
- `modules/kube`: Manages Kubernetes resources and Helm chart deployments, including:
  - **Cert-Manager**: Certificate management for Kubernetes
  - **Istio**: Service mesh with gateway configuration
  - **MetalLB**: Bare metal load balancer for Kubernetes
  - **Rancher**: Kubernetes cluster management platform
  - **Longhorn**: Distributed block storage system
  - **ArgoCD**: GitOps continuous deployment
  - **Namespaces & Certificates**: Custom namespace and certificate management
  - **Virtual Services**: Istio virtual service configurations

## Configuration
- Edit `config.yaml` in your environment directory to customize VM specs, network settings, and RKE2 options.
- Adjust `backend.tf` to change Terraform state storage (local or remote).
- Configure Kubernetes resources via the `kube` module for:
  - Ingress and load balancing (Istio + MetalLB)
  - Storage backends (Longhorn)
  - Certificate management (Cert-Manager)
  - CI/CD pipelines (ArgoCD)
  - Cluster management (Rancher)

## State Management
- State files are stored in the `states/` directory by default for the test environment.
- For production, configure remote state (e.g., S3, GCS, etc.) in `backend.tf`.

## Cleaning Up
To destroy all resources in an environment:
```bash
terraform destroy --auto-approve
```

## License
This project is licensed under the MIT License.

## Disclaimer
This lab is intended for testing and educational purposes. Use with caution in production environments.
