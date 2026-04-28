# Cert-Manager CRDs Module

Installs cert-manager Custom Resource Definitions (CRDs) via Helm chart.

## Purpose

Deploys the cert-manager CRDs helm chart as a separate release. This must be installed before the main cert-manager chart.

## Usage

```hcl
module "cert_manager_crds" {
  source = "../modules/cert_manager_crds"

  cluster_name            = "chorus-build"
  helm_registry           = "registry.example.com"
  chart_name              = "cert-manager-crds"
  chart_version           = "v1.15.0"
  helm_values             = file("path/to/values.yaml")
  cert_manager_namespace  = "cert-manager"
  kubeconfig_path         = "~/.kube/config"
  kubeconfig_context      = "my-cluster"
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `cluster_name` | Cluster name prefix for release | string | Yes |
| `helm_registry` | OCI registry for helm charts | string | Yes |
| `chart_name` | Cert-Manager CRDs chart name | string | Yes |
| `chart_version` | Chart version to install | string | Yes |
| `helm_values` | Helm values YAML content | string | Yes |
| `cert_manager_namespace` | Target namespace | string | Yes |
| `kubeconfig_path` | Path to kubeconfig | string | Yes |
| `kubeconfig_context` | Kubernetes context | string | Yes |

## Outputs

None
