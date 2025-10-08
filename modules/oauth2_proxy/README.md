# oauth2_proxy Terraform Module

This module manages the deployment and secret management for OAuth2 Proxy instances (e.g. for Prometheus, Alertmanager) in a Kubernetes cluster using Terraform. It automates the creation of required Kubernetes secrets and enforces configuration consistency for secure authentication and session storage in CHORUS-TRE.

## Features

- Creates Kubernetes secrets for OIDC authentication (client ID, client secret, cookie secret)
- Generates secure random cookie secrets for each OAuth2 Proxy instance
- Creates shared session storage secret for Redis/Valkey backend
- Manages secrets for both Prometheus and Alertmanager OAuth2 Proxy instances
- Parses Helm values to extract secret names and configuration
- Supports custom Helm values for each OAuth2 Proxy instance

## Outputs

| Name                            | Description                                                       |
|---------------------------------|-------------------------------------------------------------------|
| `prometheus_cookie_secret`      | The generated cookie secret for Prometheus OAuth2 Proxy          |
| `alertmanager_cookie_secret`    | The generated cookie secret for Alertmanager OAuth2 Proxy        |
| `session_storage_secret`        | The generated session storage password shared by both proxies    |
| `prometheus_oidc_secret_name`   | The name of the Prometheus OIDC Kubernetes Secret                |
| `alertmanager_oidc_secret_name` | The name of the Alertmanager OIDC Kubernetes Secret              |

## Variables

| Name                                  | Description                                                    | Type   | Required |
|---------------------------------------|----------------------------------------------------------------|--------|----------|
| `alertmanager_oauth2_proxy_values`    | Alertmanager OAuth2 Proxy Helm chart values (YAML)             | string | Yes      |
| `prometheus_oauth2_proxy_values`      | Prometheus OAuth2 Proxy Helm chart values (YAML)               | string | Yes      |
| `oauth2_proxy_cache_values`           | OAuth2 Proxy cache Helm chart values (e.g. Valkey, YAML)       | string | Yes      |
| `alertmanager_oauth2_proxy_namespace` | Namespace to deploy Alertmanager OAuth2 Proxy Helm chart into  | string | Yes      |
| `prometheus_oauth2_proxy_namespace`   | Namespace to deploy Prometheus OAuth2 Proxy Helm chart into    | string | Yes      |
| `oauth2_proxy_cache_namespace`        | Namespace to deploy the OAuth2 Proxy cache Helm chart into     | string | Yes      |
| `prometheus_keycloak_client_id`       | Keycloak client ID assigned to Prometheus                      | string | Yes      |
| `prometheus_keycloak_client_secret`   | Keycloak client secret assigned to Prometheus                  | string | Yes      |
| `alertmanager_keycloak_client_id`     | Keycloak client ID assigned to Alertmanager                    | string | Yes      |
| `alertmanager_keycloak_client_secret` | Keycloak client secret assigned to Alertmanager                | string | Yes      |

## Usage

```hcl
module "oauth2_proxy" {
  source = "../modules/oauth2_proxy"

  alertmanager_oauth2_proxy_values    = file("${path.module}/values/alertmanager-oauth2-proxy.yaml")
  prometheus_oauth2_proxy_values      = file("${path.module}/values/prometheus-oauth2-proxy.yaml")
  oauth2_proxy_cache_values           = file("${path.module}/values/valkey.yaml")
  
  alertmanager_oauth2_proxy_namespace = "monitoring"
  prometheus_oauth2_proxy_namespace   = "monitoring"
  oauth2_proxy_cache_namespace        = "monitoring"
  
  prometheus_keycloak_client_id       = "prometheus-client"
  prometheus_keycloak_client_secret   = var.prometheus_client_secret
  alertmanager_keycloak_client_id     = "alertmanager-client"
  alertmanager_keycloak_client_secret = var.alertmanager_client_secret
}
```

## Secrets Created

The module creates the following Kubernetes Secrets:

### OIDC Secrets (per OAuth2 Proxy instance)

**Prometheus OIDC Secret:**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: <from-helm-values>
  namespace: <prometheus_oauth2_proxy_namespace>
data:
  cookie-secret: <generated-32-char-alphanumeric>
  client-id: <prometheus_keycloak_client_id>
  client-secret: <prometheus_keycloak_client_secret>
```

**Alertmanager OIDC Secret:**
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
