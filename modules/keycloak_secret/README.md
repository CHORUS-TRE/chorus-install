# Keycloak Secret Terraform Module

This module generates and manages Kubernetes secrets for Keycloak and its OIDC clients, supporting both build and remote cluster types. It creates strong random passwords for all client secrets and the admin user, and supports Google Identity Provider integration.

## Features
- Generates random passwords for Keycloak admin and all OIDC clients
- Supports both "build" and "remote" cluster types with conditional secret creation
- Creates Kubernetes secrets for admin credentials, client credentials, and remote state encryption key
- Supports Google Identity Provider client ID and secret

## Usage Example
```hcl
module "keycloak_secret" {
  source = "../modules/keycloak_secret"

  namespace                          = var.keycloak_namespace
  admin_secret_name                  = var.keycloak_secret_name
  admin_secret_key                   = var.keycloak_secret_key
  cluster_type                       = var.cluster_type # "build" or "remote"
  client_credentials_secret_name     = var.keycloak_client_credentials_secret_name
  google_identity_provider_client_id     = var.google_identity_provider_client_id
  google_identity_provider_client_secret = var.google_identity_provider_client_secret
  remotestate_encryption_key_secret_name = var.keycloak_remotestate_encryption_key_secret_name
}
```

## Variables
| Name                                | Type   | Description                                                      | Required |
|------------------------------------- |--------|------------------------------------------------------------------|----------|
| namespace                           | string | The Kubernetes namespace for Keycloak resources                  | yes      |
| admin_secret_name                   | string | Name of the secret for Keycloak admin credentials                | yes      |
| admin_secret_key                    | string | Key in the admin secret for the password                        | yes      |
| cluster_type                        | string | "build" or "remote"; controls which secrets are created         | yes      |
| client_credentials_secret_name      | string | Name of the secret for Keycloak client credentials               | yes      |
| google_identity_provider_client_id  | string | Google Identity Provider Client ID                               | yes      |
| google_identity_provider_client_secret | string | Google Identity Provider Client Secret (sensitive)               | yes      |
| remotestate_encryption_key_secret_name | string | Name of the secret for remote state encryption key               | yes      |

## Outputs
| Name                        | Description                                              |
|-----------------------------|----------------------------------------------------------|
| admin_password              | Keycloak admin password                                  |
| argocd_client_secret        | ArgoCD client secret (build only)                        |
| argo_workflows_client_secret| Argo Workflows client secret (build only)                |
| matomo_client_secret        | Matomo client secret (remote only)                       |
| chorus_client_secret        | Chorus client secret (remote only)                       |
| grafana_client_secret       | Grafana client secret                                    |
| alertmanager_client_secret  | Alertmanager client secret                               |
| prometheus_client_secret    | Prometheus client secret                                 |
| harbor_client_secret        | Harbor client secret                                     |
| remotestate_encryption_key  | Keycloak remote state encryption key                     |

> **Note:** Outputs for client secrets are conditionally set to null if not relevant for the selected cluster_type.

## Implementation Notes
- All passwords are generated using the random_password resource for strong security.
- Only the relevant secrets for the selected cluster_type are created and output.
- Google Identity Provider credentials are passed through to the client credentials secret.

## Prerequisites
- Kubernetes cluster access
- Keycloak deployment

## References
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Keycloak Documentation](https://www.keycloak.org/)
