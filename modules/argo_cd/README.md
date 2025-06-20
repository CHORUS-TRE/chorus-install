# argo_cd Terraform Module

This module deploys and configures [ArgoCD](https://argo-cd.readthedocs.io/) and its cache (Valkey) on a Kubernetes cluster using Terraform. It automates the installation, secret management, and output of ArgoCD credentials for GitOps-based application delivery in CHORUS-TRE.

## Features

- Creates a dedicated namespace for ArgoCD
- Installs ArgoCD and its cache (Valkey) via Helm
- Manages all required Kubernetes secrets for ArgoCD and its cache
- Exposes ArgoCD URLs and admin credentials as Terraform outputs

## Outputs

| Name              | Description                  |
|-------------------|-----------------------------|
| `argocd_url`      | ArgoCD external URL          |
| `argocd_grpc_url` | ArgoCD gRPC endpoint URL     |
| `argocd_username` | ArgoCD admin username        |
| `argocd_password` | ArgoCD admin password        |

## Prerequisites

- An existing Kubernetes cluster
- Helm and Kubernetes providers configured in Terraform
- Sufficient permissions to create namespaces, secrets, and install cluster-wide resources

## References

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) 