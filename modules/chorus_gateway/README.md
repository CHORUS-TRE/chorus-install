# Chorus Gateway Module

This module deploys the Chorus Gateway Helm chart and creates OIDC client secrets for Envoy Gateway OIDC authentication.

## What it does

1. **Creates OIDC Client Secrets** - Creates kubernetes secrets in the gateway namespace with `client-secret` key (as required by Envoy Gateway)
2. **Deploys Chorus Gateway Chart** - Installs HTTPRoutes, SecurityPolicies, and other Gateway API resources for CHORUS services

## Usage

```hcl
module "chorus_gateway" {
  source = "../modules/chorus_gateway"

  cluster_name       = var.cluster_name
  helm_registry      = var.helm_registry
  chart_name         = var.chorus_gateway_chart_name
  chart_version      = local.chorus_gateway_chart_version
  helm_values        = file(local.values_files.chorus_gateway)
  gateway_namespace  = local.envoy_gateway_namespace

  oidc_client_secrets = {
    "prometheus-oidc-secret"    = module.keycloak.prometheus_keycloak_client_secret
    "alertmanager-oidc-secret"  = module.keycloak.alertmanager_keycloak_client_secret
  }

  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | Cluster name prefix | string | - | yes |
| helm_registry | Helm chart registry | string | - | yes |
| chart_name | Chorus Gateway chart name | string | - | yes |
| chart_version | Chorus Gateway chart version | string | - | yes |
| helm_values | Helm chart values (YAML) | string | - | yes |
| gateway_namespace | Gateway namespace (where secrets are created) | string | - | yes |
| kubeconfig_path | Path to kubeconfig | string | - | yes |
| kubeconfig_context | Kubeconfig context | string | - | yes |
| oidc_client_secrets | Map of OIDC secrets (name => client_secret) | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| oidc_secret_names | Names of OIDC client secrets created |

## OIDC Client Secrets

The module creates kubernetes secrets with the structure required by Envoy Gateway OIDC:

```yaml
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: <secret-name>
  namespace: <gateway-namespace>
data:
  client-secret: <base64-encoded-client-secret>
```

The secret name must match the `oidc.clientSecretName` field in the chorus-gateway values for the corresponding route.
