# keycloak_oauth2_proxy_client_config Terraform Module

This module provisions a Keycloak OpenID client for use with OAuth2 Proxy integrations (such as Prometheus or Alertmanager) using Terraform. It creates the client and configures the necessary redirect URIs and web origins.

## Features

- Provisions a Keycloak OpenID client for OAuth2 Proxy integrations
- Configures root, base, and admin URLs
- Sets allowed web origins and valid redirect URIs

## Prerequisites

- An existing Keycloak instance accessible from the environment
- Keycloak provider configured in Terraform
- Sufficient permissions to manage clients

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs) 