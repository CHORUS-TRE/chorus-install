# oauth2_proxy Terraform Module

This module manages OAuth2 Proxy secrets for Prometheus and Alertmanager on a Kubernetes cluster using Terraform. It automates the creation of OIDC configuration secrets and session storage secrets for secure OAuth2-based authentication in CHORUS-TRE.

## Features

- Generates random cookie secrets for Prometheus and Alertmanager OAuth2 Proxy
- Generates shared session storage password
- Creates OIDC configuration secrets with Keycloak client credentials for Prometheus and Alertmanager
- Creates session storage secrets for Prometheus and Alertmanager
- Creates session storage secret for OAuth2 Proxy cache (Valkey/Redis)
- All secrets are stored securely in Kubernetes with appropriate namespacing

## Outputs

| Name                      | Description                                                            |
|---------------------------|------------------------------------------------------------------------|
| `prometheus_cookie_secret`| The generated cookie secret for Prometheus OAuth2 Proxy               |
| `alertmanager_cookie_secret` | The generated cookie secret for Alertmanager OAuth2 Proxy          |
| `session_storage_secret`  | The generated session storage password shared by Prometheus and Alertmanager |

## Variables

| Name                                              | Description                                                                 | Type   | Required |
|---------------------------------------------------|-----------------------------------------------------------------------------|--------|----------|
| `alertmanager_oauth2_proxy_namespace`             | Namespace to deploy Alertmanager OAuth2 Proxy Helm chart into              | string | Yes      |
| `prometheus_oauth2_proxy_namespace`               | Namespace to deploy Prometheus OAuth2 Proxy Helm chart into                | string | Yes      |
| `oauth2_proxy_cache_namespace`                    | Namespace to deploy the OAuth2 Proxy cache Helm chart into (e.g. Valkey)   | string | Yes      |
| `prometheus_keycloak_client_id`                   | Keycloak client ID assigned to Prometheus                                   | string | Yes      |
| `prometheus_keycloak_client_secret`               | Keycloak client secret assigned to Prometheus (sensitive)                   | string | Yes      |
| `alertmanager_keycloak_client_id`                 | Keycloak client ID assigned to Alertmanager                                 | string | Yes      |
| `alertmanager_keycloak_client_secret`             | Keycloak client secret assigned to Alertmanager (sensitive)                 | string | Yes      |
| `alertmanager_session_storage_secret_name`        | Name of the Kubernetes Secret for Alertmanager OAuth2 Proxy session storage | string | Yes      |
| `alertmanager_session_storage_secret_key`         | Key within the Alertmanager session storage secret                          | string | Yes      |
| `alertmanager_oidc_secret_name`                   | Name of the Kubernetes Secret for Alertmanager OAuth2 Proxy OIDC configuration | string | Yes  |
| `prometheus_session_storage_secret_name`          | Name of the Kubernetes Secret for Prometheus OAuth2 Proxy session storage   | string | Yes      |
| `prometheus_session_storage_secret_key`           | Key within the Prometheus session storage secret                            | string | Yes      |
| `prometheus_oidc_secret_name`                     | Name of the Kubernetes Secret for Prometheus OAuth2 Proxy OIDC configuration | string | Yes    |
| `oauth2_proxy_cache_session_storage_secret_name`  | Name of the Kubernetes Secret for OAuth2 Proxy cache session storage        | string | Yes      |
| `oauth2_proxy_cache_session_storage_secret_key`   | Key within the OAuth2 Proxy cache session storage secret                    | string | Yes      |

## Prerequisites

- An existing Kubernetes cluster
- Kubernetes provider configured in Terraform
- Keycloak instance with Prometheus and Alertmanager clients configured
- OAuth2 Proxy cache (e.g., Valkey/Redis) deployed
- Sufficient permissions to create secrets in the target namespaces

## References

- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: <from-helm-values>
  namespace: <alertmanager_oauth2_proxy_namespace>
data:
  cookie-secret: <generated-32-char-alphanumeric>
  client-id: <alertmanager_keycloak_client_id>
  client-secret: <alertmanager_keycloak_client_secret>
```

### Session Storage Secrets

The module creates session storage secrets for:
- Prometheus OAuth2 Proxy (Redis/Valkey connection)
- Alertmanager OAuth2 Proxy (Redis/Valkey connection)
- OAuth2 Proxy cache (Valkey authentication)

All three secrets share the same generated password for the session storage backend.

## Secret Name Extraction

The module parses the provided Helm values YAML to extract:
- Existing secret names for OIDC configuration
- Existing secret names for session storage
- Secret key names for session storage passwords
- Ingress hostnames for URL construction

## Prerequisites

- An existing Kubernetes cluster
- Terraform configured with:
  - [Kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
  - [Random provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
- Sufficient permissions to create Secrets in the target namespaces
- Helm releases for Prometheus, Alertmanager OAuth2 Proxy and Valkey should reference the secrets created by this module

## References

- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
