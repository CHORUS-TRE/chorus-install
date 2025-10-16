# Terraform Variables

This document describes the environment variables used to deploy CHORUS on Kubernetes clusters with Terraform.
We make the distinction between the _build_ cluster, where ArgoCD is running, and the _remote_ cluster where CHORUS and its workspaces are effectively running.

## Mandatory variables

| Variable                            | Description                                                                 |
|-------------------------------------|-----------------------------------------------------------------------------|
| `kubeconfig_path`                   | Absolute path to the kubeconfig file used to connect to the build cluster.  |
| `kubeconfig_context`                | Context name in the kubeconfig file for the build cluster.                  |
| `remote_cluster_kubeconfig_path`    | Absolute path to the kubeconfig file for the remote cluster.                |
| `remote_cluster_kubeconfig_context` | Context name in the kubeconfig file for the remote cluster.                 |
| `remote_cluster_server`             | K8s API server URL of the remote cluster.                                   |
| `helm_registry`                     | OCI registry where CHORUS Helm charts are hosted. If the registry is not public, you need to set the `helm_registry_username` and `helm_registry_password` described in the optional variables.|
| `github_username`                   | GitHub username used for repository authentication. This is used to get the CHORUS wrapper Helm charts as well as their overriding Helm values.|
| `github_workbench_operator_token`   | GitHub PAT for the Workbench Operator repository. Requires read/write access. This is needed to enable the continuous integration. |
| `github_chorus_web_ui_token`        | GitHub PAT for the CHORUS Web UI repository. Requires read/write access. This is needed to enable the continuous integration. |
| `github_images_token`               | GitHub PAT for images repository. Requires read/write access. This is needed to enable the continuous integration. |
| `github_chorus_backend_token`       | GitHub PAT for the CHORUS backend repository. Requires read/write access. This is needed to enable the continuous integration. |
| `i2b2_db_password`                  | Password for the i2b2 database. A limitation of the i2b2 Helm chart is that this password cannot be randomly generated. |

## Optional variables

| Variable                                 | Description                                                                 | Default                |
|------------------------------------------|-----------------------------------------------------------------------------|------------------------|
| `cluster_name`                           | Cluster name used as a prefix for releases. Falls back to `kubeconfig_context` if unset. | `""` |
| `remote_cluster_name`                    | Remote cluster name used as a prefix for releases. Falls back to `remote_cluster_kubeconfig_context`. | `""` |
| `remote_cluster_insecure`                | Disable TLS verification for the remote cluster. Used when configuring ArgoCD's remote cluster connection | `"false"`              |
| `github_orga`                            | GitHub organization where CHORUS repos reside.                              | `"CHORUS-TRE"`         |
| `helm_registry_username`                 | Username for authenticating to a private Helm registry.                     | `""` |
| `helm_registry_password`                 | Password for authenticating to a private Helm registry.                     | `""` |
| `helm_values_repo`                       | Repository containing overriding Helm values.                               | `"environment-template"` |
| `chorus_release`                         | Version tag of the CHORUS release. Existing `helm_values_repo` branch name is supported as well. | `"v0.1.0-alpha"`       |
| `helm_values_credentials_secret`         | Kubernetes secret name holding GitHub credentials for ArgoCD to read Helm values repo.      | `"argo-cd-github-environments"` |
| `helm_values_path`                       | Local path to Helm values files.                                            | `"../values"`          |
| `helm_values_pat`                        | GitHub PAT for private Helm values repos (read-only).                       | `""`                 |
| `ingress_nginx_chart_name`               | Helm chart name for ingress-nginx.                                          | `"ingress-nginx"`      |
| `cert_manager_chart_name`                | Helm chart name for cert-manager.                                           | `"cert-manager"`       |
| `selfsigned_chart_name`                  | Helm chart name for self-signed issuer.                                     | `"self-signed-issuer"` |
| `valkey_chart_name`                      | Helm chart name for Valkey.                                                 | `"valkey"`             |
| `keycloak_chart_name`                    | Helm chart name for Keycloak.                                               | `"keycloak"`           |
| `postgresql_chart_name`                  | Helm chart name for PostgreSQL.                                             | `"postgresql"`         |
| `harbor_chart_name`                      | Helm chart name for Harbor.                                                 | `"harbor"`             |
| `keycloak_realm`                         | Keycloak realm name for CHORUS infra services.                              | `"infra"`              |
| `keycloak_client_id`                     | Keycloak client ID for Harbor.                                              | `"harbor"`             |
| `keycloak_oidc_admin_group`              | Keycloak group assigned admin rights in Harbor.                             | `"HarborAdmins"`       |
| `harbor_admin_username`                  | Harbor administrator username.                                              | `"admin"`              |
| `harbor_keycloak_base_url`               | Keycloak OIDC base URL for Harbor integration.                              | `"/harbor/projects"`   |
| `argocd_harbor_robot_username`           | Harbor robot account for ArgoCD.                                            | `"argo-cd"`            |
| `chorusci_harbor_robot_username`         | Harbor robot account for CHORUS CI.                                         | `"chorus-ci"`          |
| `argocd_keycloak_client_id`              | Keycloak client ID for ArgoCD.                                              | `"argo-cd"`            |
| `argocd_keycloak_oidc_admin_group`       | Keycloak group assigned admin rights in ArgoCD.                             | `"ArgoCDAdmins"`       |
| `argocd_keycloak_base_url`               | Keycloak OIDC base URL for ArgoCD integration.                              | `"/applications"`      |
| `didata_app_key`                         | Application key for DiData integration.                                     | `""`                   |
| `didata_registry_password`               | Registry password for DiData.                                               | `""`                   |
| `google_identity_provider_client_id`     | Google Identity Provider Client ID (for OIDC federation).                   | `""`                   |
| `google_identity_provider_client_secret` | Google Identity Provider Client Secret.                                     | `""`                   |
| `webex_access_token`                     | Webex bot access token for sending alerts.                                  | `""`                   |
| `remote_cluster_webex_access_token`      | Webex bot access token for sending alerts from the remote cluster.          | `""`                   |