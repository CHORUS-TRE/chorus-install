# Terraform Variables

This document describes the environment variables used to deploy CHORUS on Kubernetes clusters with Terraform.
We make the distinction between the _build_ cluster, where ArgoCD is running, and the _remote_ cluster where CHORUS, its workspaces and sessions, are effectively running.

## Mandatory variables

| Variable                            | Description                                                                 |
|-------------------------------------|-----------------------------------------------------------------------------|
| `cluster_name`                      | Cluster name used as a prefix for releases.                                 |
| `github_app_id`                     | GitHub App ID for ArgoCD repository access and Argo Workflows event source. See [this section](#github_app). |
| `github_app_installation_id`        | GitHub App Installation ID for ArgoCD repository access. See [this section](#github_app). |
| `github_app_private_key`            | GitHub App private key for ArgoCD repository access and Argo Workflows event source. See [this section](#github_app). |
| `github_pat`                        | GitHub Personal Access Token used by Argo Workflows for repository access. Requires read/write access to code, commit statuses, and pull requests. See [this section](#github_pat). |
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
| `github_orga` | GitHub organization where CHORUS repos reside | `"CHORUS-TRE"` |
| `helm_registry_password` | Password for authenticating to a private Helm registry | `""` |
| `helm_registry_username` | Username for authenticating to a private Helm registry | `""` |
| `helm_values_repo` | Repository containing overriding Helm values | `"environment-template"` |

### Helm Chart Names

| Variable | Description | Default |
|----------|-------------|---------|
| `cert_manager_chart_name` | Helm chart name for cert-manager. The corresponding folder within `helm_values_repo` needs to have the same name | `"cert-manager"` |
| `cert_manager_crds_chart_name` | Helm chart name for cert-manager CRDs. The corresponding folder within `helm_values_repo` needs to have the same name | `"cert-manager-crds"` |
| `chorus_gateway_chart_name` | Helm chart name for Chorus Gateway (HTTPRoutes and SecurityPolicies). The corresponding folder within `helm_values_repo` needs to have the same name | `"chorus-gateway"` |
| `envoy_gateway_chart_name` | Helm chart name for Envoy Gateway. The corresponding folder within `helm_values_repo` needs to have the same name | `"gateway-helm"` |
| `envoy_gateway_crds_chart_name` | Helm chart name for Gateway API CRDs. The corresponding folder within `helm_values_repo` needs to have the same name | `"gateway-crds-helm"` |
| `harbor_chart_name` | Helm chart name for Harbor. The corresponding folder within `helm_values_repo` needs to have the same name | `"harbor"` |
| `keycloak_chart_name` | Helm chart name for Keycloak. The corresponding folder within `helm_values_repo` needs to have the same name | `"keycloak"` |
| `postgresql_chart_name` | Helm chart name for PostgreSQL. The corresponding folder within `helm_values_repo` needs to have the same name | `"postgresql"` |
| `selfsigned_chart_name` | Helm chart name for self-signed issuer. The corresponding folder within `helm_values_repo` needs to have the same name | `"self-signed-issuer"` |
| `valkey_chart_name` | Helm chart name for Valkey. The corresponding folder within `helm_values_repo` needs to have the same name | `"valkey"` |

### TLS Certificate Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `cloudflare_api_token` | Cloudflare API token for DNS-01 challenge. If provided, a secret will be created in cert-manager namespace for use in ClusterIssuers. Requires `Zone:DNS:Edit` permissions for your domain. See [this section](#cloudflare_dns01) | `""` |

### Identity Provider Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `google_identity_provider_client_id` | Google Identity Provider Client ID (for OIDC federation). See [this section](#google_idp) | `""` |
| `google_identity_provider_client_secret` | Google Identity Provider Client Secret. See [this section](#google_idp) | `""` |
| `remote_cluster_google_identity_provider_client_id` | Remote cluster's Google Identity Provider Client ID (for OIDC federation). See [this section](#google_idp) | `""` |
| `remote_cluster_google_identity_provider_client_secret` | Remote cluster's Google Identity Provider Client Secret. See [this section](#google_idp) | `""` |

### Alerting Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `remote_cluster_webex_access_token` | Webex bot access token for sending alerts from the remote cluster. See [this section](#webex_alerts) | `""` |
| `webex_access_token` | Webex bot access token for sending alerts. See [this section](#webex_alerts) | `""` |

### Remote Storage Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `s3_access_key` | S3 access key for JuiceFS storage backend | `""` |
| `s3_bucket_name` | S3 bucket name for JuiceFS storage backend | `""` |
| `s3_endpoint` | S3 endpoint URL for JuiceFS storage backend | `""` |
| `s3_secret_key` | S3 secret key for JuiceFS storage backend | `""` |

### Logging and Observability Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `loki_s3_access_key_id` | S3 access key ID for Loki storage backend (build cluster) | `""` |
| `loki_s3_secret_access_key` | S3 secret access key for Loki storage backend (build cluster) | `""` |
| `remote_cluster_loki_s3_access_key_id` | S3 access key ID for Loki storage backend (remote cluster) | `""` |
| `remote_cluster_loki_s3_secret_access_key` | S3 secret access key for Loki storage backend (remote cluster) | `""` |

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

The GitHub PAT is used by Argo Workflows to authenticate when accessing repositories during CI/CD workflows.

**Required permissions:**
- Read access to actions, metadata, and repository hooks
- Read and Write access to code, commit statuses, and pull requests

Go through the following documentation to set up your GitHub PAT: [creating-a-fine-grained-personal-access-token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)

<a id="github_app"></a>
## GitHub App

The GitHub App is used for:
1. **ArgoCD repository access**: To read Helm values from the environment repository
2. **Argo Workflows event source**: To configure GitHub webhooks for continuous integration across all CHORUS repositories (Workbench Operator, Web UI, Images, Backend)

**Setup steps:**
1. Create a GitHub App in your organization or personal account
2. Grant the app the following permissions:
   - Read access to contents (for ArgoCD to read repository files)
   - Read access to metadata
   - Read and Write access to webhooks (for Argo Workflows event source)
3. Install the app on the required repositories (environment repository and CHORUS code repositories)
4. Generate and download a private key
5. Note the App ID and Installation ID from the GitHub App settings page
6. Use the following values:
   - `github_app_id`: The App ID from the GitHub App settings
   - `github_app_installation_id`: The Installation ID (found in the app's installations page)
   - `github_app_private_key`: The private key content

Go through the following documentation to set up your GitHub App: [creating-a-github-app](https://docs.github.com/en/apps/creating-github-apps/about-creating-github-apps/about-creating-github-apps)

<a id="google_idp"></a>
## Google Identity Provider

Go through the "Google Application" section of the following blog post to set up the Google identity provider and retrieve the `google_identity_provider_client_id` and `google_identity_provider_client_secret` variables:
[Configure Keycloak to use Google as an IdP](https://medium.com/codeshakeio/configure-keycloak-to-use-google-as-an-idp-4e3c59583345)

<a id="webex_alerts"></a>
## Webex Alerts

Go through the following blog post to set up the Webex robots and retrieve the `webex_access_token` and `remote_cluster_webex_access_token` variables:
[Broadcasting prometheus alerts to webex space.](https://dev.to/akshay_awate_215ba6a285dc/broadcast-prometheus-alerts-to-webex-space-21gc)

<a id="cloudflare_dns01"></a>
## Cloudflare API Token for DNS-01 Challenge

The `cloudflare_api_token` variable is used to create wildcard TLS certificates using the DNS-01 ACME challenge. This is optional and only needed if you want to use wildcard certificates (e.g., `*.example.com`).

**Required steps:**
1. Log in to your Cloudflare dashboard
2. Navigate to My Profile > API Tokens
3. Create a new API token with the following permissions:
   - Zone: DNS: Edit (for your specific zone)
4. Copy the generated token and use it as the value for `cloudflare_api_token`

The token will be stored as a Kubernetes secret in the `cert-manager` namespace and can be referenced in ClusterIssuer configurations in the cert-manager helm values.

See the Cloudflare documentation: [Creating API tokens](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)