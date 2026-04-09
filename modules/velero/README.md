# Velero Terraform Module

This module manages the Velero namespace and S3 credentials on a Kubernetes cluster using Terraform. The Velero deployment itself is handled by ArgoCD.

## Features

- Creates the Velero namespace
- Creates Kubernetes secret containing AWS S3 credentials for Velero
- Formats credentials in the AWS credentials file format expected by Velero
- Supports S3-compatible storage backends

## Variables

| Name                       | Description                                                    | Type   | Default                    | Required | Sensitive |
|----------------------------|----------------------------------------------------------------|--------|----------------------------|----------|----------|
| `namespace`                | Name of the Kubernetes namespace to create for Velero          | string | -                          | Yes      | No       |
| `credentials_secret_name`  | Name of the Kubernetes secret to store credentials             | string | -                          | Yes      | No       |
| `access_key_id`            | S3 access key ID for Velero backup storage                     | string | -                          | Yes      | Yes      |
| `secret_access_key`        | S3 secret access key for Velero backup storage                 | string | -                          | Yes      | Yes      |

## Prerequisites

- An existing Kubernetes cluster
- Kubernetes provider configured in Terraform
- S3-compatible storage for Velero backups

## Usage

```hcl
module "velero" {
  source = "./modules/velero"

  namespace                = "velero"
  credentials_secret_name  = "velero-s3-credentials"

  access_key_id       = var.velero_s3_access_key_id
  secret_access_key   = var.velero_s3_secret_access_key
}
```

## Secret Created

### velero-s3-credentials (or custom name)

Contains a `cloud` key with AWS credentials in the format:

```
[default]
aws_access_key_id=<access_key>
aws_secret_access_key=<secret_key>
```

This format is compatible with Velero's AWS plugin and can be referenced in the Velero BackupStorageLocation configuration.

## Integration with Velero

The secret created by this module should be referenced in your Velero BackupStorageLocation:

```yaml
apiVersion: velero.io/v1
kind: BackupStorageLocation
metadata:
  name: default
  namespace: velero
spec:
  provider: aws
  credential:
    name: velero-s3-credentials
    key: cloud
  objectStorage:
    bucket: my-backup-bucket
  config:
    region: us-east-1
    s3Url: https://s3.example.com
```
