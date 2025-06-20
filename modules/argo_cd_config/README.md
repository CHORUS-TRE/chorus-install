# argo_cd_config Terraform Module

This module configures [ArgoCD](https://argo-cd.readthedocs.io/) projects and application sets in an existing ArgoCD instance using Terraform. It automates the setup of OIDC secrets, ArgoCD projects, and application sets for CHORUS-TRE.

## Features

- Creates and manages OIDC secrets for ArgoCD authentication
- Waits for ArgoCD server readiness before applying configuration
- Provisions ArgoCD projects and application sets for automated deployment

## Outputs

_This module does not define explicit Terraform outputs. All resources are managed internally. To use created projects or secrets, reference them by their configured names in your ArgoCD instance._

## Prerequisites

- An existing ArgoCD instance deployed in the cluster
- ArgoCD and Kubernetes providers configured in Terraform
- Sufficient permissions to manage secrets and ArgoCD resources

## References

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/en/stable/)
- [Terraform ArgoCD Provider](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) 