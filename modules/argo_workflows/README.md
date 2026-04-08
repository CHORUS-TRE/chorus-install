# Argo Workflows Terraform Module

This module manages the installation of Argo Workflows and the creation of workflow namespaces and OIDC secrets for SSO integration with Keycloak.

## Features
- Installs Argo Workflows in a specified namespace (optionally skips creation if using an existing namespace like `kube-system`).
- Creates additional workflow namespaces, ensuring the main install namespace is not duplicated.
- Manages Kubernetes secrets for OIDC client ID and secret, supporting split or combined secrets.

## Usage Example
```hcl
module "argo_workflows" {
  source = "../modules/argo_workflows"

  namespace                    = "argo-workflows"
  workflows_namespaces         = ["team-a", "team-b"]
  keycloak_client_id           = var.keycloak_client_id
  keycloak_client_secret       = var.keycloak_client_secret
  sso_server_client_id_name    = "argo-oidc-client-id"
  sso_server_client_id_key     = "client-id"
  sso_server_client_secret_name = "argo-oidc-client-secret"
  sso_server_client_secret_key  = "client-secret"
}
```

## Variables
| Name                         | Type        | Description                                                        | Required |
|------------------------------|-------------|--------------------------------------------------------------------|----------|
| namespace                    | string      | The namespace where Argo Workflows will be deployed                | yes      |
| workflows_namespaces         | set(string) | The namespaces where Argo Workflows will run workflows             | yes      |
| keycloak_client_id           | string      | The Keycloak client ID for OIDC authentication                     | yes      |
| keycloak_client_secret       | string      | The Keycloak client secret for OIDC authentication                 | yes      |
| sso_server_client_id_name    | string      | The Kubernetes secret name for the OIDC client ID                  | yes      |
| sso_server_client_id_key     | string      | The key within the secret for the OIDC client ID                   | yes      |
| sso_server_client_secret_name| string      | The Kubernetes secret name for the OIDC client secret              | yes      |
| sso_server_client_secret_key | string      | The key within the secret for the OIDC client secret               | yes      |

## Outputs
This module does not currently export any outputs.

## Implementation Notes
- The module will not attempt to create the namespace if it is set to `kube-system` (or already exists).
- Workflow namespaces are created using `setsubtract` to avoid duplicating the main install namespace.
- OIDC secrets can be created as a single secret or split into separate secrets for ID and secret, depending on the provided names.

## Prerequisites
- Kubernetes cluster access
- Keycloak OIDC client configured

## References
- [Argo Workflows](https://argoproj.github.io/argo-workflows/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
