# remote_cluster_harbor_config Terraform Module

This module configures [Harbor](https://goharbor.io/) for a remote cluster in the CHORUS-TRE multi-cluster setup. It creates Harbor projects, robot accounts with granular permissions, and optionally configures registry replication for synchronizing container images between clusters.

## Features

- Creates Harbor projects: `apps`, `chorus`, and `services`
- Provisions a cluster robot account with pull permissions for all projects
- Optionally provisions a build robot account with comprehensive system-level permissions (used for push-based replication)
- Supports both push-based and pull-based replication strategies
- Configures vulnerability scanning settings for projects
- Generates secure random passwords for robot accounts

## Outputs

| Name                     | Description                                                  |
|--------------------------|--------------------------------------------------------------|
| `cluster_robot_password` | Password of the robot user used by the cluster's components  |
| `build_robot_password`   | Password of the robot user used by the Chorus build cluster (null if not created) |

## Variables

| Name                              | Description                                                      | Type   | Required | Default |
|-----------------------------------|------------------------------------------------------------------|--------|----------|---------|
| `cluster_robot_username`          | The username of the robot account used for registry credentials  | string | Yes      | -       |
| `build_robot_username`            | The username of the robot account used for replication (push-based) | string | No    | ""      |
| `pull_replication_registry_name`  | The name of the registry to replicate from (pull-based)          | string | No       | ""      |
| `pull_replication_registry_url`   | The URL of the registry to replicate from (pull-based)           | string | No       | ""      |

## Usage

```hcl
module "remote_cluster_harbor_config" {
  source = "../modules/remote_cluster_harbor_config"

  cluster_robot_username         = "remote-cluster-01"
  pull_replication_registry_name = "build-cluster"
  pull_replication_registry_url  = "https://harbor.build.example.com"
}
```

## Harbor Projects

The module creates the following Harbor projects:

| Project Name | Purpose                           | Vulnerability Scanning |
|--------------|-----------------------------------|------------------------|
| `apps`       | Application container images      | Disabled               |
| `chorus`     | CHORUS-TRE core components        | Disabled               |
| `services`   | Supporting services and utilities | Disabled               |

All projects are configured with `force_destroy = true` for easier cleanup during development.

## Robot Accounts

### Cluster Robot Account

**Purpose**: Used by Kubernetes nodes and ArgoCD to pull container images

**Level**: System

**Permissions**:
- **System Level**:
  - List projects
  - List and read registries
- **Project Level** (apps, chorus, services):
  - List and read artifacts
  - List, pull, and read repositories
  - List tags

### Build Robot Account (Optional)

**Purpose**: Used for replication from the build cluster (push-based strategy)

**Level**: System

**Conditionally Created**: Only when `build_robot_username` is not empty

## Replication Strategies

The module supports two replication strategies:

### Push-Based Replication

- Set `build_robot_username` to create a robot account on the remote cluster
- The build cluster pushes images to the remote cluster using this robot account
- Robot account has comprehensive permissions for replication operations

### Pull-Based Replication

- Set `pull_replication_registry_name` and `pull_replication_registry_url`
- The remote cluster pulls images from the build cluster
- Creates registry endpoint and replication rules automatically
- Supports filtering and scheduled replication

## Prerequisites

- An existing Harbor instance accessible from the environment
- Terraform configured with the [Harbor provider](https://registry.terraform.io/providers/goharbor/harbor/latest/docs)
- Sufficient permissions to create projects, robot accounts, registries, and replication rules
- For pull-based replication: public source registry

## References

- [Harbor Documentation](https://goharbor.io/docs/)
- [Terraform Harbor Provider](https://registry.terraform.io/providers/goharbor/harbor/latest/docs)
- [Harbor Replication Guide](https://goharbor.io/docs/latest/administration/configuring-replication/) 