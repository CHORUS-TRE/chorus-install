# keycloak Terraform Module

This module deploys and configures [Keycloak](https://www.keycloak.org/) and its database on a Kubernetes cluster using Terraform. It automates the installation, secret management, and output of Keycloak credentials for secure identity and access management in CHORUS-TRE.

## Features

- Creates a dedicated namespace for Keycloak
- Installs Keycloak and its database (PostgreSQL) via Helm
- Manages all required Kubernetes secrets for Keycloak and its database
- Exposes Keycloak URL and admin credentials as Terraform outputs

## Outputs

| Name              | Description                        |
|-------------------|------------------------------------|
| `keycloak_url`    | Keycloak external URL              |
| `keycloak_password` | Keycloak admin password          |

## Prerequisites

- An existing Kubernetes cluster
- Helm and Kubernetes providers configured in Terraform
- Sufficient permissions to create namespaces, secrets, and install cluster-wide resources

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) 