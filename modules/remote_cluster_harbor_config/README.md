# harbor_config Terraform Module

This module configures [Harbor](https://goharbor.io/) projects, robot accounts, and registry integrations in a Harbor instance using Terraform. It automates the setup of projects, robot accounts for CI/CD, and the import of Helm charts for CHORUS-TRE.

## Features

- Creates and manages Harbor projects for different workloads
- Provisions robot account for ArgoCD with appropriate permissions
- Adds external registries (e.g., Docker Hub) to Harbor
- Automates the initial population of the Harbor registry with Helm charts
- Exposes robot account passwords as Terraform outputs

## Outputs

| Name                     | Description                                      |
|--------------------------|--------------------------------------------------|
| `argocd_robot_password`  | Password of the robot user used by ArgoCD        |

## Prerequisites

- An existing Harbor instance accessible from the environment
- Harbor provider configured in Terraform
- Sufficient permissions to manage projects, robot accounts, and registries

## References

- [Harbor Documentation](https://goharbor.io/docs/)
- [Terraform Harbor Provider](https://registry.terraform.io/providers/goharbor/harbor/latest/docs) 