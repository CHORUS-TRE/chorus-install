# keycloak Terraform Module

This module deploys and configures [Keycloak](https://www.keycloak.org/) and its database on a Kubernetes cluster using Terraform. It automates the installation, secret management, and output of Keycloak credentials for secure identity and access management in CHORUS-TRE.

## Features

- Creates a dedicated namespace for Keycloak
- Installs Keycloak and its database (PostgreSQL) via Helm
- Manages all required Kubernetes secrets for Keycloak and its database
- Exposes Keycloak admin credentials as Terraform outputs
- Disables metrics collection by default (can be enabled via values)

## Outputs

| Name                        | Description                              |
|-----------------------------|------------------------------------------|
| `keycloak_password`         | Keycloak admin password                  |
| `keycloak_db_password`      | Keycloak DB password for Keycloak user   |
| `keycloak_db_admin_password`| Keycloak DB password for PostgreSQL user |

## Variables

| Name                          | Description                                                     | Type   | Required |
|-------------------------------|-----------------------------------------------------------------|--------|----------|
| `cluster_name`                | The cluster name to be used as a prefix to release names        | string | Yes      |
| `helm_registry`               | Helm chart registry to get the chart from                       | string | Yes      |
| `keycloak_chart_name`         | Keycloak Helm chart name                                        | string | Yes      |
| `keycloak_chart_version`      | Keycloak Helm chart version                                     | string | Yes      |
| `keycloak_helm_values`        | Keycloak Helm chart values (YAML format)                        | string | Yes      |
| `keycloak_namespace`          | Namespace to deploy Keycloak Helm chart into                    | string | Yes      |
| `keycloak_db_chart_name`      | Keycloak DB Helm chart name                                     | string | Yes      |
| `keycloak_db_chart_version`   | Keycloak DB (e.g. PostgreSQL) Helm chart version                | string | Yes      |
| `keycloak_db_helm_values`     | Keycloak DB (e.g. PostgreSQL) Helm chart values (YAML format)   | string | Yes      |
| `keycloak_secret_name`        | Name of the Kubernetes Secret containing Keycloak credentials   | string | Yes      |
| `keycloak_secret_key`         | The specific key within the Keycloak secret to retrieve         | string | Yes      |
| `keycloak_db_secret_name`     | Name of the Kubernetes Secret containing Keycloak database credentials | string | Yes |
| `keycloak_db_admin_secret_key`| The specific key within the Keycloak database secret to retrieve the admin password | string | Yes |
| `keycloak_db_user_secret_key` | The specific key within the Keycloak database secret to retrieve the user password | string | Yes |

## Prerequisites

- An existing Kubernetes cluster
- Helm and Kubernetes providers configured in Terraform
- Sufficient permissions to create namespaces, secrets, and install cluster-wide resources

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) 