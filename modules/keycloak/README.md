# keycloak Terraform Module

This module deploys and configures [Keycloak](https://www.keycloak.org/) and its database on a Kubernetes cluster using Terraform. It automates the installation, secret management, and output of Keycloak credentials for secure identity and access management in CHORUS-TRE.

## Features

- Creates a dedicated namespace for Keycloak
- Installs Keycloak and its database (PostgreSQL) via Helm
- Manages all required Kubernetes secrets for Keycloak and its database
- Generates random passwords for Keycloak admin and client applications
- Supports cluster-specific client configurations (build vs remote)
- Configures Google identity provider integration
- Generates client secrets for multiple applications (ArgoCD, Argo Workflows, Grafana, Alertmanager, Prometheus, Harbor, Matomo, Chorus)
- Creates remote state encryption key for Keycloak configuration
- Exposes Keycloak admin and client credentials as Terraform outputs
- Disables metrics collection by default (can be enabled via values)

## Outputs

| Name                                  | Description                                          | Build Cluster | Remote Cluster |
|---------------------------------------|------------------------------------------------------|---------------|----------------|
| `keycloak_password`                   | Keycloak admin password                              | ✓             | ✓              |
| `keycloak_db_password`                | Keycloak DB password for Keycloak user               | ✓             | ✓              |
| `keycloak_db_admin_password`          | Keycloak DB password for PostgreSQL user             | ✓             | ✓              |
| `argocd_keycloak_client_secret`       | ArgoCD Keycloak client secret                        | ✓             | null           |
| `argo_workflows_keycloak_client_secret` | Argo Workflows Keycloak client secret              | ✓             | null           |
| `grafana_keycloak_client_secret`      | Grafana Keycloak client secret                       | ✓             | ✓              |
| `alertmanager_keycloak_client_secret` | Alertmanager Keycloak client secret                  | ✓             | ✓              |
| `prometheus_keycloak_client_secret`   | Prometheus Keycloak client secret                    | ✓             | ✓              |
| `harbor_keycloak_client_secret`       | Harbor Keycloak client secret                        | ✓             | ✓              |
| `matomo_keycloak_client_secret`       | Matomo Keycloak client secret                        | null          | ✓              |
| `chorus_keycloak_client_secret`       | Chorus Keycloak client secret                        | null          | ✓              |

## Variables

| Name                                            | Description                                                                      | Type   | Required | Default                              |
|-------------------------------------------------|----------------------------------------------------------------------------------|--------|----------|--------------------------------------|
| `cluster_name`                                  | The cluster name to be used as a prefix to release names                         | string | Yes      | -                                    |
| `cluster_type`                                  | The type of cluster - determines which set of Keycloak clients to configure (must be 'build' or 'remote') | string | Yes | - |
| `helm_registry`                                 | Helm chart registry to get the chart from                                        | string | Yes      | -                                    |
| `keycloak_chart_name`                           | Keycloak Helm chart name                                                         | string | Yes      | -                                    |
| `keycloak_chart_version`                        | Keycloak Helm chart version                                                      | string | Yes      | -                                    |
| `keycloak_helm_values`                          | Keycloak Helm chart values (YAML format)                                         | string | Yes      | -                                    |
| `keycloak_namespace`                            | Namespace to deploy Keycloak Helm chart into                                     | string | Yes      | -                                    |
| `keycloak_db_chart_name`                        | Keycloak DB Helm chart name                                                      | string | Yes      | -                                    |
| `keycloak_db_chart_version`                     | Keycloak DB (e.g. PostgreSQL) Helm chart version                                 | string | Yes      | -                                    |
| `keycloak_db_helm_values`                       | Keycloak DB (e.g. PostgreSQL) Helm chart values (YAML format)                    | string | Yes      | -                                    |
| `keycloak_secret_name`                          | Name of the Kubernetes Secret containing Keycloak credentials                    | string | Yes      | -                                    |
| `keycloak_secret_key`                           | The specific key within the Keycloak secret to retrieve                          | string | Yes      | -                                    |
| `keycloak_db_secret_name`                       | Name of the Kubernetes Secret containing Keycloak database credentials           | string | Yes      | -                                    |
| `keycloak_db_admin_secret_key`                  | The specific key within the Keycloak database secret to retrieve the admin password | string | Yes   | -                                    |
| `keycloak_db_user_secret_key`                   | The specific key within the Keycloak database secret to retrieve the user password | string | Yes    | -                                    |
| `google_identity_provider_client_id`            | Google identity provider client ID for Keycloak                                  | string | Yes      | -                                    |
| `google_identity_provider_client_secret`        | Google identity provider client secret for Keycloak (sensitive)                  | string | Yes      | -                                    |
| `keycloak_client_credentials_secret_name`       | Name of the Kubernetes Secret containing Keycloak client credentials             | string | Yes      | -                                    |
| `keycloak_remotestate_encryption_key_secret_name` | Name of the Kubernetes Secret containing Keycloak remote state encryption key  | string | Yes      | -                                    |

## Prerequisites

- An existing Kubernetes cluster
- Helm and Kubernetes providers configured in Terraform
- Sufficient permissions to create namespaces, secrets, and install cluster-wide resources

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
