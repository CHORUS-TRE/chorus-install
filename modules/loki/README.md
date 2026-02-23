# loki Terraform Module

This module manages Loki secrets on a Kubernetes cluster using Terraform. The Loki deployment itself is handled by ArgoCD. The namespace is shared with Prometheus and is not created by this module.

## Features

- Generates random passwords for Loki clients (Fluent Bit, Grafana, etc.)
- Creates htpasswd file with bcrypt-hashed passwords for basic authentication
- Creates Kubernetes secret `loki-gateway-htpasswd` containing the htpasswd file
- Creates Kubernetes secret `loki-s3-credentials` for S3 storage access
- Uses existing Prometheus namespace

## Variables

| Name                     | Description                                                    | Type   | Required | Sensitive |
|--------------------------|----------------------------------------------------------------|--------|----------|-----------|
| `namespace`              | The Kubernetes namespace where Loki is deployed (shared with Prometheus) | string | Yes      | No        |
| `loki_clients`           | List of Loki client objects with `name` field. Passwords are auto-generated. | list(object) | Yes | No |
| `s3_access_key_id`       | S3 access key ID for Loki storage                              | string | Yes      | Yes       |
| `s3_secret_access_key`   | S3 secret access key for Loki storage                          | string | Yes      | Yes       |

## Outputs

| Name                     | Description                                      | Sensitive |
|--------------------------|--------------------------------------------------|-----------|
| `loki_client_passwords`  | Map of Loki client names to their generated passwords | Yes       |

## Prerequisites

- An existing Kubernetes cluster
- Kubernetes provider configured in Terraform
- Prometheus namespace already created
- S3-compatible storage for Loki

## Usage

```hcl
module "loki" {
  source = "./modules/loki"

  namespace = "prometheus"
  
  loki_clients = [
    { name = "chorus-dev-fluentbit" },
    { name = "chorus-dev-grafana" }
  ]
  
  s3_access_key_id     = var.loki_s3_access_key_id
  s3_secret_access_key = var.loki_s3_secret_access_key
}
```

## Secrets Created

### loki-gateway-htpasswd
Contains the `.htpasswd` file with bcrypt-hashed passwords for each client specified in `loki_clients`.

### loki-s3-credentials
Contains `accessKeyId` and `secretAccessKey` for S3 storage access.
