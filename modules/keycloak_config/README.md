# keycloak_config Terraform Module

This module configures [Keycloak](https://www.keycloak.org/) realms, clients, groups, and scopes using Terraform. It automates the setup of realms, OpenID clients, client groups, and client scopes for CHORUS-TRE.

## Features

- Creates and configures a Keycloak realm
- Provisions OpenID clients with confidential access
- Manages client groups and assigns them to clients
- Configures OpenID client scopes and optional scopes

## Outputs

_This module does not define explicit Terraform outputs. All resources are managed internally. To use created realms, clients, or groups, reference them by their configured names in your Keycloak instance._

## Prerequisites

- An existing Keycloak instance accessible from the environment
- Keycloak provider configured in Terraform
- Sufficient permissions to manage realms, clients, and groups

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs) 