# JuiceFS Terraform Module

This module deploys and configures [JuiceFS](https://juicefs.com/) CSI driver secrets on a Kubernetes cluster using Terraform.  
It automates the creation of Kubernetes secrets required for JuiceFS cache, dashboard, and storage backends, making it easier to integrate JuiceFS into CHORUS-TRE.

## Features

- Generates strong random passwords for JuiceFS cache and dashboard secrets
- Creates Kubernetes secrets for:
  - JuiceFS cache authentication
  - JuiceFS dashboard access
  - JuiceFS CSI driver storage credentials
- Dynamically constructs a Redis `metaurl` pointing to the JuiceFS cache
- Supports S3-compatible object storage as the JuiceFS backend

## Outputs

This module does not currently define explicit Terraform outputs, but the created secrets can be referenced in dependent modules or Helm releases.  
For example:
- `juicefs-cache` secret containing the cache password
- `juicefs-dashboard` secret with username and password
- `juicefs-secret` for CSI driver configuration

## Prerequisites

- An existing Kubernetes cluster
- Terraform configured with:
  - [Kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
  - [Random provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
- Sufficient permissions to create Kubernetes secrets in the target namespaces
- An accessible S3-compatible object storage (with access/secret key)
- A Redis deployment for JuiceFS metadata (the module assumes a `valkey` Redis cluster in the target namespace)

## Variables

| Name                         | Description                                                     | Type   |
|------------------------------|-----------------------------------------------------------------|--------|
| `juicefs_cache_secret_name`  | Name of the Kubernetes Secret used for JuiceFS cache credentials | string |
| `juicefs_cache_namespace`    | Namespace where the JuiceFS cache Secret is located             | string |
| `juicefs_dashboard_secret_name` | Name of the Kubernetes Secret containing JuiceFS dashboard credentials | string |
| `juicefs_csi_driver_namespace` | Namespace where the JuiceFS CSI driver is deployed            | string |
| `juicefs_dashboard_username` | Username used to authenticate to the JuiceFS dashboard          | string |
| `s3_access_key`              | Access key for the S3-compatible object storage                 | string |
| `s3_secret_key`              | Secret key for the S3-compatible object storage                 | string |
| `cluster_name`               | Name of the Kubernetes cluster where JuiceFS is deployed        | string |
| `s3_endpoint`                | Endpoint URL of the S3-compatible object storage                | string |
| `s3_bucket_name`             | Name of the S3 bucket to use for JuiceFS storage                | string |

## References

- [JuiceFS Documentation](https://juicefs.com/docs/community/introduction)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)