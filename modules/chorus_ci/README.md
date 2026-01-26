# ChorusCI Terraform Module

This module deploys ChorusCI and manages all required secrets for GitHub integration and workflow automation. It supports dynamic webhook event secret mapping and registry authentication.

## Features
- Deploys ChorusCI in a specified namespace
- Creates secrets for GitHub tokens for multiple components (Workbench Operator, Web UI, Images, Backend)
- Supports dynamic mapping of webhook event names to secret names via a single input map
- Manages Docker registry credentials for sensors

## Usage Example
```hcl
module "chorus_ci" {
  source = "../modules/chorus_ci"

  chorusci_namespace   = "chorus-ci"
  webhook_events       = {
    "workbench-operator" = "workbench-operator-secret"
    "chorus-web-ui"      = "web-ui-secret"
    "ci"                 = "ci-secret"
    "chorus-backend"     = "backend-secret"
  }
  sensor_regcred_secret_name = "sensor-regcred"

  github_chorus_web_ui_token      = var.github_chorus_web_ui_token
  github_images_token             = var.github_images_token
  github_chorus_backend_token     = var.github_chorus_backend_token
  github_workbench_operator_token = var.github_workbench_operator_token
  github_username                 = var.github_username

  registry_server   = var.registry_server
  registry_username = var.registry_username
  registry_password = var.registry_password
}
```

## Variables
| Name                         | Type        | Description                                                        | Required |
|------------------------------|-------------|--------------------------------------------------------------------|----------|
| chorusci_namespace           | string      | Namespace where ChorusCI is deployed                               | yes      |
| webhook_events               | map(string) | Map of webhook event names to secret names                         | yes      |
| sensor_regcred_secret_name   | string      | Name of the sensor Docker registry credentials secret               | yes      |
| github_chorus_web_ui_token   | string      | GitHub token for Chorus Web UI repo                                | yes      |
| github_images_token          | string      | GitHub token for Images repo                                       | yes      |
| github_chorus_backend_token  | string      | GitHub token for Chorus Backend repo                               | yes      |
| github_workbench_operator_token | string   | GitHub token for Workbench Operator repo                           | yes      |
| github_username              | string      | GitHub username for Argo Workflows                                 | yes      |
| registry_server              | string      | Container registry server (e.g. Harbor)                            | yes      |
| registry_username            | string      | Robot username for the container registry                          | yes      |
| registry_password            | string      | Robot password for the container registry                          | yes      |

## Outputs
This module does not currently export any outputs.

## Implementation Notes
- All webhook event secret names are provided via the webhook_events map for flexibility.
- Sensor registry credentials are managed via a dedicated secret.
- All GitHub tokens are sensitive and must be provided securely.

## Prerequisites
- Kubernetes cluster access
- Valid GitHub tokens for all required repositories
- Docker registry credentials

## References
- [ChorusCI Documentation](https://github.com/CHORUS-TRE/chorus-ci)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
