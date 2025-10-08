# Helm Charts Values Module

This module fetches Helm chart values from a Git repository and downloads cert-manager CRDs for CHORUS-TRE deployments.

## Purpose

Automates the retrieval and management of:
- Helm chart values files from a Git repository (using sparse checkout)
- Cert-manager wrapper chart version information
- Cert-manager application version from chart dependencies
- Cert-manager CRDs from GitHub releases

## Features

- **Sparse Git Checkout**: Fetches only the required cluster-specific values, not the entire repository
- **Version Extraction**: Extracts both wrapper chart version and actual cert-manager app version
- **Automatic CRD Download**: Downloads correct cert-manager CRDs based on app version
- **Private Repository Support**: Handles authentication for private GitHub repositories
- **Private Registry Support**: Authenticates with private OCI registries for Helm charts
- **Cleanup on Destroy**: Automatically removes fetched files when resources are destroyed
- **Smart Triggers**: Only re-fetches when release, cluster, or repository changes

## Usage

```hcl
module "helm_charts_values" {
  source = "../modules/helm_charts_values"

  cluster_name            = "build-cluster"
  github_orga             = "CHORUS-TRE"
  helm_values_repo        = "chorus-helm-values"
  helm_values_path        = "helm-values"
  helm_values_pat         = var.github_pat
  chorus_release          = "v1.0.0"
  cert_manager_chart_name = "cert-manager"
  helm_registry           = "harbor.example.com"
  helm_registry_username  = "admin"
  helm_registry_password  = var.harbor_password
  cert_manager_crds_path  = "crds"
}
```

## Requirements

- Terraform >= 1.8.0
- External provider >= 2.3.5
- Null provider >= 3.2.4
- Local provider >= 2.5.2
- HTTP provider >= 3.4.5

### External Dependencies

The module requires the following tools to be available in the execution environment:
- `git` - For sparse checkout of values repository
- `helm` - For pulling charts from OCI registry
- `yq` - For parsing YAML chart metadata
- `tar` - For extracting chart archives

## Inputs

| Name | Description | Type | Required | Sensitive |
|------|-------------|------|----------|-----------|
| `github_orga` | GitHub organization to use repositories from | `string` | Yes | No |
| `helm_values_repo` | Git repository name containing Helm values files | `string` | Yes | No |
| `helm_values_path` | Local path where Helm values are stored | `string` | Yes | No |
| `helm_values_pat` | GitHub Personal Access Token for private repos | `string` | Yes | Yes |
| `chorus_release` | Chorus release identifier (branch/tag) | `string` | Yes | No |
| `cluster_name` | Kubernetes cluster name | `string` | Yes | No |
| `cert_manager_chart_name` | Cert-Manager Helm chart name | `string` | Yes | No |
| `helm_registry` | OCI registry URL hosting Helm charts | `string` | Yes | No |
| `helm_registry_username` | Helm registry authentication username | `string` | Yes | No |
| `helm_registry_password` | Helm registry authentication password | `string` | Yes | Yes |
| `cert_manager_crds_path` | Local path for cert-manager CRDs | `string` | Yes | No |

## Outputs

| Name | Description |
|------|-------------|
| `cert_manager_crds_path` | Full path to the downloaded cert-manager CRDs file |

## Workflow

The module performs the following steps:

### 1. Fetch Helm Values (null_resource)
```
1. Initialize git repository in temporary location
2. Add remote based on GitHub org and repo name
3. Fetch specific release/branch
4. Use sparse checkout to get only cluster-specific values
5. Copy values to target location
6. Clean up temporary git directory
```

### 2. Extract Chart Version (external data source)
```
1. Read config.json from fetched values
2. Extract wrapper chart version
3. Store in local.cert_manager_chart_version
```

### 3. Extract App Version (external data source)
```
1. Login to Helm registry (if private)
2. Pull cert-manager chart using wrapper version
3. Extract actual cert-manager version from Chart.yaml dependencies
4. Store in local.cert_manager_app_version
5. Clean up temporary files
```

### 4. Download CRDs (http data source)
```
1. Download CRDs from GitHub releases
2. URL: github.com/cert-manager/cert-manager/releases/download/{version}/cert-manager.crds.yaml
```

### 5. Save CRDs (local_file)
```
1. Write CRDs to local file
2. Path: {cert_manager_crds_path}/{cluster_name}/cert-manager.crds.yaml
```

## Version Management

CHORUS uses **wrapper Helm charts** where:
- `cert_manager_chart_version` = Version of the CHORUS wrapper chart
- `cert_manager_app_version` = Version of the actual Jetstack cert-manager

The wrapper chart references the official cert-manager as a dependency, and this module extracts both versions to ensure the correct CRDs are downloaded.

## Authentication

### GitHub Repository
- **Public**: No PAT needed (set to any value, will use "public")
- **Private**: Provide valid GitHub PAT via `helm_values_pat`

### Helm Registry
- **Public**: No credentials needed (set to any value, will use "public")
- **Private**: Provide username and password

## Triggers

The module re-runs when:
- `chorus_release` changes (new version)
- `cluster_name` changes (different cluster)
- `helm_values_repo` changes (different repository)

Does NOT re-run on every apply (no timestamp trigger).

## Notes

- Sparse checkout minimizes bandwidth and storage by fetching only needed values
- The destroy provisioner ensures cleanup of fetched files
- The module handles both public and private repositories/registries gracefully
- Chart version extraction uses external data sources with shell scripts
- CRDs are downloaded directly from cert-manager GitHub releases
