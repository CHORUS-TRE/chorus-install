# certificate_authorities Terraform Module

This module deploys and configures certificate authorities (CAs) in a Kubernetes cluster using Terraform. It automates the installation of Cert-Manager and a self-signed issuer, which are required for secure service communication in CHORUS-TRE environments.

## Features

- Installs Cert-Manager and its Custom Resource Definitions (CRDs)
- Deploys a self-signed certificate issuer (e.g., for PostgreSQL)
- Supports custom Helm values for both Cert-Manager and the self-signed issuer
- Ensures proper resource dependencies and readiness

## Outputs

_This module does not define explicit Terraform outputs. All resources are managed internally. To use generated secrets or certificates, reference them by their configured names in your Kubernetes cluster._

## Prerequisites

- An existing Kubernetes cluster
- Helm and Kubernetes providers configured in Terraform
- Sufficient permissions to create namespaces, CRDs, and secrets

## References

- [Cert-Manager Documentation](https://cert-manager.io/docs/)
- [Kubernetes TLS Management](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) 