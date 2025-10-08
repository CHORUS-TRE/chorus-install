# keycloak_grafana_client_config Terraform Module

This module provisions a Keycloak OpenID client and related groups/roles for Grafana integration using Terraform. It creates the client, a hierarchical group structure, and assigns roles for Grafana access control.

## Features

- Provisions a Keycloak OpenID client for Grafana via the `keycloak_generic_client_config` module
- Creates a hierarchical group structure:
  - Parent client group
  - Editors group (child of parent)
  - Administrators group (child of Editors)
- Creates custom client roles: `admin` and `editor`
- Assigns roles to groups for Grafana RBAC integration
- Configures root, base, and admin URLs, web origins, and redirect URIs

## Outputs

| Name               | Description                                  |
|--------------------|----------------------------------------------|
| `client_id`        | The ID of the created Grafana Keycloak client|
| `editors_group_id` | The ID of the Grafana Editors group          |
| `admins_group_id`  | The ID of the Grafana Administrators group   |
| `admin_role_id`    | The ID of the Grafana admin role             |
| `editor_role_id`   | The ID of the Grafana editor role            |

## Variables

| Name                   | Description                                          | Type         | Required |
|------------------------|------------------------------------------------------|--------------|----------|
| `realm_id`             | The ID of the realm where to create the Grafana client| string      | Yes      |
| `client_id`            | The Grafana client ID                                | string       | Yes      |
| `client_secret`        | The Grafana client secret                            | string       | Yes      |
| `root_url`             | The root URL of the Grafana client                   | string       | Yes      |
| `base_url`             | The base URL of the Grafana client                   | string       | Yes      |
| `admin_url`            | The admin URL of the Grafana client                  | string       | Yes      |
| `web_origins`          | A list of allowed web origins for the Grafana client | list(string) | Yes      |
| `valid_redirect_uris`  | A list of valid redirect URIs for the Grafana client | list(string) | Yes      |
| `client_group`         | The name of the Grafana client group to create       | string       | Yes      |

## Usage

```hcl
module "keycloak_grafana_client_config" {
  source = "../modules/keycloak_grafana_client_config"

  realm_id            = "chorus-infra"
  client_id           = "grafana-client"
  client_secret       = var.grafana_client_secret
  root_url            = "https://grafana.example.com"
  base_url            = "/"
  admin_url           = "https://grafana.example.com"
  web_origins         = ["https://grafana.example.com"]
  valid_redirect_uris = ["https://grafana.example.com/login/generic_oauth"]
  client_group        = "grafana-users"
}
```

## Group Hierarchy

The module creates the following group hierarchy:

```
client_group (parent, provided by keycloak_generic_client_config)
└── Editors
    └── Administrators
```

## Role Assignments

- **Editors group**: Assigned the `editor` role
- **Administrators group**: Assigned the `admin` role

Users in the Administrators group inherit the `editor` role through group hierarchy.

## Prerequisites

- An existing Keycloak instance accessible from the environment
- Terraform configured with the [Keycloak provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- Sufficient permissions to manage clients, groups, and roles in the target realm

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- [Grafana OAuth Configuration](https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/generic-oauth/) 