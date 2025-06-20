# harbor Terraform Module

This module deploys and configures [Harbor](https://goharbor.io/) on a Kubernetes cluster using Terraform. It automates the installation of Harbor, its database, cache, and all required secrets for secure container registry operations in CHORUS-TRE.

## Features

- Creates a dedicated namespace for Harbor
- Installs Harbor, its database (PostgreSQL), and cache (Valkey) via Helm
- Manages all required Kubernetes secrets for Harbor and its components
- Configures OIDC authentication with Keycloak
- Exposes Harbor URLs and credentials as Terraform outputs

## Outputs

| Name                      | Description                                             |
|---------------------------|---------------------------------------------------------|
| `harbor_url`              | Harbor external URL                                     |
| `harbor_url_admin_login`  | Harbor admin login URL                                  |
| `harbor_username`         | Harbor admin username                                   |
| `harbor_password`         | Harbor admin password                                   |

## Prerequisites

- An existing Kubernetes cluster
- Helm and Kubernetes providers configured in Terraform
- Sufficient permissions to create namespaces, secrets, and install cluster-wide resources

## References

- [Harbor Documentation](https://goharbor.io/docs/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) 