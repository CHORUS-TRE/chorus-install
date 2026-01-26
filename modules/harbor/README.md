# harbor Terraform Module

This module deploys and configures [Harbor](https://goharbor.io/) on a Kubernetes cluster using Terraform. It automates the installation of Harbor, its database, cache, and all required secrets for secure container registry operations in CHORUS-TRE.

## Features

- Creates a dedicated namespace for Harbor
- Installs Harbor, its database (PostgreSQL), and cache (Valkey) via Helm
- Manages all required Kubernetes secrets for Harbor and its components
- Generates random passwords for Harbor admin, registry, job service, and database
- Creates robot account secrets for automated access
- Configures OIDC authentication with Keycloak
- Disables metrics collection by default (can be enabled via values)
- Exposes Harbor credentials and robot account secrets as Terraform outputs

## Outputs

| Name                      | Description                                             |
|---------------------------|---------------------------------------------------------|
| `harbor_password`         | Harbor admin password                                   |
| `harbor_db_password`      | Harbor DB password for Harbor user                      |
| `harbor_db_admin_password`| Harbor DB password for PostgreSQL admin user            |
| `harbor_robot_secrets`    | Map of Harbor robot account names to their secrets      |

## Prerequisites

- An existing Kubernetes cluster
- Helm and Kubernetes providers configured in Terraform
- Sufficient permissions to create namespaces, secrets, and install cluster-wide resources
- PostgreSQL and Valkey/Redis compatible storage

## References

- [Harbor Documentation](https://goharbor.io/docs/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)