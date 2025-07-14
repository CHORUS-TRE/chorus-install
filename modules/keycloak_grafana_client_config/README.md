# keycloak_grafana_client_config Terraform Module

This module provisions a Keycloak OpenID client and related groups/roles for Grafana integration using Terraform. It creates the client, a group hierarchy, and assigns roles for Grafana access control.

## Features

- Provisions a Keycloak OpenID client for Grafana
- Creates a group hierarchy for Grafana users (including Editors and Administrators)
- Assigns custom roles to groups for fine-grained access control
- Configures root, base, and admin URLs, web origins, and redirect URIs

## Prerequisites

- An existing Keycloak instance accessible from the environment
- Keycloak provider configured in Terraform
- Sufficient permissions to manage clients, groups, and roles

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs) 