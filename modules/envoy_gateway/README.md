# Envoy Gateway Module

This module installs Envoy Gateway and Gateway API resources to provide ingress capabilities.

## What it does

1. **Creates Namespaces** - `envoy-gateway-system` for the controller and the specified namespace for Gateway resources
2. **Installs Gateway API CRDs** - Via `gateway-crds-helm` chart
3. **Deploys Gateway Resources** - Via `gateway-helm` chart (EnvoyProxy, GatewayClass, Gateway)
4. **Waits for LoadBalancer** - Waits for LoadBalancer IP to be provisioned

## Differences from ingress-nginx

| Feature | ingress-nginx | Envoy Gateway |
|---------|--------------|---------------|
| API | Ingress (v1) | Gateway API (v1) |
| Resources | Ingress | Gateway + HTTPRoute |
| Annotations | nginx-specific | Gateway API native |
| TLS | Per-Ingress | Per-Gateway or HTTPRoute |
| Configuration | Annotations + ConfigMap | GatewayClass + Gateway |

## Usage

```hcl
module "envoy_gateway" {
  source = "../modules/envoy_gateway"

  cluster_name  = var.cluster_name
  helm_registry = var.helm_registry

  gateway_crds_chart_name    = var.envoy_gateway_crds_chart_name
  gateway_crds_chart_version = local.envoy_gateway_crds_chart_version
  gateway_crds_helm_values   = file(local.values_files.envoy_gateway_crds)

  gateway_chart_name    = var.envoy_gateway_chart_name
  gateway_chart_version = local.envoy_gateway_chart_version
  gateway_helm_values   = file(local.values_files.envoy_gateway)
  gateway_namespace     = local.envoy_gateway_namespace

  kubeconfig_path    = var.kubeconfig_path
  kubeconfig_context = var.kubeconfig_context
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | Cluster name prefix | string | - | yes |
| helm_registry | Helm chart registry | string | - | yes |
| kubeconfig_path | Path to kubeconfig | string | - | yes |
| kubeconfig_context | Kubeconfig context | string | - | yes |
| gateway_crds_chart_name | Gateway API CRDs chart name | string | - | yes |
| gateway_crds_chart_version | Gateway API CRDs chart version | string | - | yes |
| gateway_crds_helm_values | Gateway API CRDs helm values (YAML) | string | "" | no |
| gateway_chart_name | Gateway helm chart name | string | - | yes |
| gateway_chart_version | Gateway helm chart version | string | - | yes |
| gateway_helm_values | Gateway helm values (YAML) | string | - | yes |
| gateway_namespace | Namespace for Gateway resource | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| loadbalancer_ip | LoadBalancer IP |

## Gateway API Resources

- **GatewayClass**: Defines the controller (Envoy Gateway)
- **Gateway**: LoadBalancer + listeners (HTTP/HTTPS)
- **HTTPRoute**: Routing rules
- **TLSRoute**: L4 TLS routing
- **TCPRoute**: L4 TCP routing

## Requirements

- Kubernetes >= 1.27
- LoadBalancer provisioner (cloud provider or MetalLB)

## Troubleshooting

### Gateway not getting IP

```bash
kubectl describe gateway <cluster-name>-gateway -n <namespace>
kubectl get svc -n <gateway-namespace> | grep envoy
```

### HTTPRoute not working

```bash
kubectl describe httproute <route-name> -n <namespace>
# Check parentRef matches Gateway name/namespace
```

### Check Envoy Gateway logs

```bash
kubectl logs -n envoy-gateway-system deployment/envoy-gateway
```

## References

- [Gateway API Documentation](https://gateway-api.sigs.k8s.io/)
- [Envoy Gateway Documentation](https://gateway.envoyproxy.io/)
