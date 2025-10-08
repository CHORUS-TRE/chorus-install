# Cert-Manager CRDs Module

This module applies Cert-Manager Custom Resource Definitions (CRDs) to a Kubernetes cluster.

## Purpose

Deploys Cert-Manager CRDs from YAML content using the Kubernetes provider's `manifest_decode_multi` function to parse and apply multiple manifests dynamically.

## Features

- Parses multiple YAML manifests from a single string
- Creates individual `kubernetes_manifest` resources for each CRD
- Uses CRD name as the resource key for stable state management
- Validates YAML content before application

## Usage

```hcl
module "cert_manager_crds" {
  source = "../modules/cert_manager_crds"

  cert_manager_crds_content = file("${path.module}/crds/cert-manager.crds.yaml")
}
```

## Requirements

- Terraform >= 1.8.0 (required for provider functions)
- Kubernetes provider >= 2.36.0

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `cert_manager_crds_content` | YAML content of the Cert-Manager CRDs to be applied. Should contain one or more Kubernetes manifests in YAML format. | `string` | Yes |

## Outputs

This module has no outputs.

## Notes

- The module uses `provider::kubernetes::manifest_decode_multi` to split multi-document YAML into individual manifests
- Each CRD is tracked separately in Terraform state using its metadata.name as the key
- CRDs are typically applied before deploying Cert-Manager itself
