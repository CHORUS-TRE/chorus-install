# Terraform Variables

This document describes the environment variables used to deploy CHORUS on Kubernetes clusters with Terraform.
We make the distinction between the _build_ cluster, where ArgoCD is running, and the _remote_ cluster where CHORUS, its workspaces and sessions, are effectively running.

## Mandatory variables

| Variable                            | Description                                                                 |
|-------------------------------------|-----------------------------------------------------------------------------|
| `cluster_name`                      | Cluster name used as a prefix for releases.                                 |
| `github_chorus_backend_token`       | GitHub PAT for the CHORUS backend repository. Requires read/write access. This is needed to enable the continuous integration. See [this section](#github_pat). |
| `github_chorus_web_ui_token`        | GitHub PAT for the CHORUS Web UI repository. Requires read/write access. This is needed to enable the continuous integration. See [this section](#github_pat). |
| `github_images_token`               | GitHub PAT for images repository. Requires read/write access. This is needed to enable the continuous integration. See [this section](#github_pat). |
| `github_username`                   | GitHub username used for repository authentication. This is used to get the CHORUS wrapper Helm charts as well as their overriding Helm values.|
| `github_workbench_operator_token`   | GitHub PAT for the Workbench Operator repository. Requires read/write access. This is needed to enable the continuous integration. See [this section](#github_pat). |
| `helm_registry`                     | OCI registry where CHORUS Helm charts are hosted. If the registry is not public, you need to set the `helm_registry_username` and `helm_registry_password` described in the optional variables.|
| `i2b2_db_password`                  | Password for the i2b2 database. A limitation of the i2b2 Helm chart is that this password cannot be randomly generated. |
| `kubeconfig_context`                | Context name in the kubeconfig file for the build cluster.                  |
| `kubeconfig_path`                   | Absolute path to the kubeconfig file used to connect to the build cluster.  |
| `remote_cluster_kubeconfig_context` | Context name in the kubeconfig file for the remote cluster.                 |
| `remote_cluster_kubeconfig_path`    | Absolute path to the kubeconfig file for the remote cluster.                |
| `remote_cluster_name`               | Remote cluster name used as a prefix for releases.                          |
| `remote_cluster_server`             | K8s API server URL of the remote cluster.                                   |

## Optional variables

### GitHub, Helm Registry and Repository Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `chorus_release` | Version tag of the CHORUS release. Existing `helm_values_repo` branch name is supported as well | `"v0.1.0-alpha"` |
| `github_orga` | GitHub organization where CHORUS repos reside | `"CHORUS-TRE"` |
| `helm_registry_password` | Password for authenticating to a private Helm registry | `""` |
| `helm_registry_username` | Username for authenticating to a private Helm registry | `""` |
| `helm_values_credentials_secret` | Kubernetes secret name holding GitHub credentials for ArgoCD to read Helm values repo | `"argo-cd-github-environments"` |
| `helm_values_pat` | GitHub PAT for private Helm values repos (read-only). See [this section](#github_pat) | `""` |
| `helm_values_path` | Local path to Helm values files | `"../values"` |
| `helm_values_repo` | Repository containing overriding Helm values | `"environment-template"` |

### Helm Chart Names

| Variable | Description | Default |
|----------|-------------|---------|
| `cert_manager_chart_name` | Helm chart name for cert-manager. The corresponding folder within `helm_values_repo` needs to have the same name | `"cert-manager"` |
| `harbor_chart_name` | Helm chart name for Harbor. The corresponding folder within `helm_values_repo` needs to have the same name | `"harbor"` |
| `ingress_nginx_chart_name` | Helm chart name for ingress-nginx. The corresponding folder within `helm_values_repo` needs to have the same name | `"ingress-nginx"` |
| `keycloak_chart_name` | Helm chart name for Keycloak. The corresponding folder within `helm_values_repo` needs to have the same name | `"keycloak"` |
| `postgresql_chart_name` | Helm chart name for PostgreSQL. The corresponding folder within `helm_values_repo` needs to have the same name | `"postgresql"` |
| `selfsigned_chart_name` | Helm chart name for self-signed issuer. The corresponding folder within `helm_values_repo` needs to have the same name | `"self-signed-issuer"` |
| `valkey_chart_name` | Helm chart name for Valkey. The corresponding folder within `helm_values_repo` needs to have the same name | `"valkey"` |

### Identity Provider Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `google_identity_provider_client_id` | Google Identity Provider Client ID (for OIDC federation). See [this section](#google_idp) | `""` |
| `google_identity_provider_client_secret` | Google Identity Provider Client Secret. See [this section](#google_idp) | `""` |

### Alerting Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `remote_cluster_webex_access_token` | Webex bot access token for sending alerts from the remote cluster. See [this section](#webex_alerts) | `""` |
| `webex_access_token` | Webex bot access token for sending alerts. See [this section](#webex_alerts) | `""` |

### Applications Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `argocd_harbor_robot_username` | Harbor robot account for ArgoCD | `"argo-cd"` |
| `argocd_keycloak_base_url` | Keycloak OIDC base URL for ArgoCD integration | `"/applications"` |
| `argocd_keycloak_client_id` | Keycloak client ID for ArgoCD | `"argo-cd"` |
| `argocd_keycloak_oidc_admin_group` | Keycloak group assigned admin rights in ArgoCD | `"ArgoCDAdmins"` |
| `chorusci_harbor_robot_username` | Harbor robot account for CHORUS CI | `"chorus-ci"` |
| `didata_app_key` | Application key for DiData integration | `""` |
| `didata_registry_password` | Registry password for DiData | `""` |
| `harbor_admin_username` | Harbor administrator username | `"admin"` |
| `harbor_keycloak_base_url` | Keycloak OIDC base URL for Harbor integration | `"/harbor/projects"` |
| `keycloak_client_id` | Keycloak client ID for Harbor | `"harbor"` |
| `keycloak_oidc_admin_group` | Keycloak group assigned admin rights in Harbor | `"HarborAdmins"` |
| `keycloak_realm` | Keycloak realm name for CHORUS infra services | `"infra"` |

### Remote Cluster TLS Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `remote_cluster_insecure` | Disable TLS verification for the remote cluster. Used when configuring ArgoCD's remote cluster connection | `"false"` |

<a id="github_pat"></a>
## GitHub Personal Access Token

Go through the following documentation to set up your GitHub PAT: [creating-a-fine-grained-personal-access-token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)

<a id="google_idp"></a>
## Google Identity Provider

Go through the "Google Application" section of the following blog post to set up the Google identity provider and retrieve the `google_identity_provider_client_id` and `google_identity_provider_client_secret` variables:
[Configure Keycloak to use Google as an IdP](https://medium.com/codeshakeio/configure-keycloak-to-use-google-as-an-idp-4e3c59583345)

<a id="webex_alerts"></a>
## Webex Alerts

Go through the following blog post to set up the Webex robots and retrieve the `webex_access_token` and `remote_cluster_webex_access_token` variables:
[Broadcasting prometheus alerts to webex space.](https://dev.to/akshay_awate_215ba6a285dc/broadcast-prometheus-alerts-to-webex-space-21gc)