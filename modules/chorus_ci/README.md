# ChorusCI Terraform Module

This module deploys ChorusCI and manages all required secrets for GitHub integration and workflow automation. It supports dynamic webhook event secret mapping, GitHub PAT/App authentication, and registry authentication.

## Features
- Deploys ChorusCI in a specified namespace
- Creates webhook secrets for multiple components (Workbench Operator, Web UI, Images, Backend)
- Creates shared Argo Workflows GitHub PAT and GitHub App secrets
- Supports dynamic mapping of webhook event names to secret names via a single input map
- Manages Docker registry credentials for sensors

## Usage Example
```hcl
module "chorus_ci" {
  source = "../modules/chorus_ci"

  chorusci_namespace = "chorus-ci"
  webhook_events_map = {
    "workbench-operator" = {
      secretName = "workbench-operator-webhook"
      secretKey  = "webhookSecret"
    }
    "chorus-web-ui" = {
      secretName = "chorus-web-ui-webhook"
      secretKey  = "webhookSecret"
    }
    "ci" = {
      secretName = "images-webhook"
      secretKey  = "webhookSecret"
    }
    "chorus-backend" = {
      secretName = "chorus-backend-webhook"
      secretKey  = "webhookSecret"
    }
  }

  github_pat                = var.github_pat
  github_app_private_key    = var.github_app_private_key
  github_pat_secret_name    = "chorus-build-argo-workflows-github-pat"
  github_app_secret_name    = "chorus-build-argo-workflows-github-app"

  sensor_regcred_secret_name = "sensor-regcred"
  registry_server            = var.registry_server
  registry_username          = var.registry_username
  registry_password          = var.registry_password
}
```

## Variables
| Name                         | Type             | Description                                                        | Required |
|------------------------------|------------------|--------------------------------------------------------------------|----------|
| chorusci_namespace           | string           | Namespace where ChorusCI is deployed                               | yes      |
| webhook_events_map           | map(map(string)) | Map of webhook events to their secret name and key                 | yes      |
| github_pat                   | string           | GitHub Personal Access Token for Argo Workflows                    | yes      |
| github_app_private_key       | string           | GitHub App private key for Argo Workflows                          | yes      |
| github_pat_secret_name       | string           | Name of the Kubernetes secret for GitHub PAT                       | yes      |
| github_app_secret_name       | string           | Name of the Kubernetes secret for GitHub App                       | yes      |
| sensor_regcred_secret_name   | string           | Name of the sensor Docker registry credentials secret              | yes      |
| registry_server              | string           | Container registry server (e.g. Harbor)                            | yes      |
| registry_username            | string           | Robot username for the container registry                          | yes      |
| registry_password            | string           | Robot password for the container registry                          | yes      |

## Outputs
This module does not currently export any outputs.

## Implementation Notes
- Webhook secrets contain only the webhook secret value (no tokens)
- GitHub authentication is centralized via shared PAT and GitHub App secrets for Argo Workflows
- PAT secret contains `username: x-access-token` and `password: <PAT>`
- GitHub App secret contains `privateKey: <private_key>`
- Sensor registry credentials are managed via a dedicated secret
- All sensitive values are marked as sensitive and must be provided securely

## Prerequisites
- Kubernetes cluster access
- Valid GitHub tokens for all required repositories
- Docker registry credentials

## References
- [ChorusCI Documentation](https://github.com/CHORUS-TRE/chorus-ci)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
