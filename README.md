# Azure AKS with ACR Infrastructure

This Terraform configuration creates an Azure Kubernetes Service (AKS) cluster with an Azure Container Registry (ACR), complete with virtual network integration and proper RBAC setup.

## Infrastructure Components

- Azure Resource Group
- Azure Kubernetes Service (AKS)
- Azure Container Registry (ACR)
- Virtual Network and Subnet
- Role Assignment for AKS to pull from ACR

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 3.0
- Azure CLI installed and authenticated
- Azure subscription

## Configuration

### Variables

The following variables can be configured in `variables.tf` or via command line:

- `resource_group_location` (default: "southeastasia")
- `resource_group_name_prefix` (default: "rg")
- `acr_name` (default: "naufalseira")

## Usage

1. Prepare your working directory:
```bash
terraform init
```
2. Check whether the configuration is valid:
```bash
terraform validate
```
3. Show changes required by the current configuration:
```bash
terraform plan
```
4. Create or update infrastructure:
```bash
terraform apply 
```
5. Destroy previously-created infrastructure:
```bash
terraform destroy 
```

## Features

### AKS Cluster:
- System-assigned managed identity
- Auto-scaling enabled (1-3 nodes)
- Availability zones enabled
- Uses Standard_B2ls_v2 VM size
- Azure CNI networking

### ACR:
- Standard SKU
- Admin access enabled
- Integrated with AKS via RBAC

### Networking:
- Custom VNet (10.1.0.0/16)
- Dedicated subnet (10.1.0.0/24)
- Azure CNI network plugin
- Standard load balancer

## Outputs 
- Resource group name
- Kubernetes cluster name
- Kubernetes cluster DNS prefix
- ACR login server
- ACR admin username
- ACR admin password (sensitive)
- Kubernetes cluster kubeconfig (sensitive)

## Important Notes
- The AKS cluster uses system-assigned managed identity
- Auto-scaling is configured with a minimum of 1 and maximum of 3 nodes
- The cluster is deployed across two availability zones
- ACR has admin access enabled for simplified authentication