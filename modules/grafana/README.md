# grafana Terraform Module

This module manages Grafana namespace and secrets on a Kubernetes cluster using Terraform. It automates the creation of the namespace and the configuration of OAuth authentication with Keycloak for secure access in CHORUS-TRE.

## Features

- Creates a dedicated namespace for Grafana
- Generates random admin password for Grafana
- Manages Kubernetes secret containing Grafana admin credentials and OAuth client secret
- Configures Keycloak OAuth client secret for authentication
- Stores all credentials securely in a single Kubernetes secret

## Variables

| Name                                  | Description                                                       | Type   | Required |
|---------------------------------------|-------------------------------------------------------------------|--------|----------|
| `namespace`                           | The Kubernetes namespace where Grafana is deployed                | string | Yes      |
| `grafana_admin_username`              | The username of the Grafana admin                                 | string | Yes      |
| `grafana_oauth_client_secret_name`    | Name of the Kubernetes Secret containing Grafana OAuth client credentials | string | Yes |
| `grafana_oauth_client_secret_key`     | Key within the OAuth secret that stores the client secret         | string | Yes      |
| `grafana_keycloak_client_secret`      | Keycloak client secret for Grafana OAuth authentication (sensitive) | string | Yes   |

## Outputs

This module does not expose any outputs.

## Prerequisites

- An existing Kubernetes cluster
- Kubernetes provider configured in Terraform
- Keycloak instance with Grafana client configured
- Sufficient permissions to create namespaces and secrets

## References

- [Grafana Documentation](https://grafana.com/docs/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
