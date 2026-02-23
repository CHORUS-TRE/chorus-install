# fluent_operator Terraform Module

This module manages the Fluent Operator namespace and secrets on a Kubernetes cluster using Terraform. The Fluent Operator deployment itself is handled by ArgoCD.

## Features

- Creates a dedicated namespace for Fluent Operator
- Creates Kubernetes secret `loki-client-credentials` for Loki authentication

## Variables

| Name                | Description                                      | Type   | Required | Sensitive |
|---------------------|--------------------------------------------------|--------|----------|-----------|
| `namespace`         | The Kubernetes namespace where Fluent Operator is deployed | string | Yes      | No        |
| `loki_http_user`    | HTTP basic auth username for Loki connection     | string | Yes      | Yes       |
| `loki_http_password`| HTTP basic auth password for Loki connection     | string | Yes      | Yes       |
| `loki_tenant_id`    | Tenant ID for Loki multi-tenancy                 | string | Yes      | No        |

## Outputs

This module does not expose any outputs.

## Prerequisites

- An existing Kubernetes cluster
- Kubernetes provider configured in Terraform
- Loki instance with HTTP basic authentication enabled

## Usage

```hcl
module "fluent_operator" {
  source = "./modules/fluent_operator"

  namespace          = "fluent"
  loki_http_user     = module.loki.loki_client_passwords["${var.cluster_name}-fluentbit"]
  loki_http_password = module.loki.loki_client_passwords["${var.cluster_name}-fluentbit"]
  loki_tenant_id     = var.cluster_name
}
```

## Secrets Created

### loki-client-credentials
Contains HTTP basic authentication credentials and tenant ID for connecting to Loki.
