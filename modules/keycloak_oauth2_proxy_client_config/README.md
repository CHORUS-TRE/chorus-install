# keycloak_oauth2_proxy_client_config Terraform Module

This module provisions a Keycloak OpenID client for use with OAuth2 Proxy integrations (such as Prometheus or Alertmanager) using Terraform. It creates the client, configures the necessary redirect URIs and web origins, and adds an audience protocol mapper for proper token validation.

## Features

- Provisions a Keycloak OpenID client for OAuth2 Proxy integrations via the `keycloak_generic_client_config` module
- Configures root, base, and admin URLs
- Sets allowed web origins and valid redirect URIs
- Adds an audience protocol mapper to include the client ID in the token audience claim
- Suitable for securing applications behind OAuth2 Proxy (Prometheus, Alertmanager, etc.)

## Outputs

| Name                 | Description                                |
|----------------------|--------------------------------------------|
| `client_id`          | The ID of the created Keycloak client      |
| `audience_mapper_id` | The ID of the audience protocol mapper     |

## Variables

| Name                   | Description                                      | Type         | Required |
|------------------------|--------------------------------------------------|--------------|----------|
| `realm_id`             | The ID of the realm where to create the client   | string       | Yes      |
| `client_id`            | The client ID                                    | string       | Yes      |
| `client_secret`        | The client secret                                | string       | Yes      |
| `root_url`             | The root URL of the client                       | string       | Yes      |
| `base_url`             | The base URL of the client                       | string       | Yes      |
| `admin_url`            | The admin URL of the client                      | string       | Yes      |
| `web_origins`          | A list of allowed web origins for the client     | list(string) | Yes      |
| `valid_redirect_uris`  | A list of valid redirect URIs for the client     | list(string) | Yes      |

## Usage

```hcl
module "keycloak_alertmanager_client_config" {
  source = "../modules/keycloak_oauth2_proxy_client_config"

  realm_id            = "chorus-infra"
  client_id           = "alertmanager-client"
  client_secret       = var.alertmanager_client_secret
  root_url            = "https://alertmanager.example.com"
  base_url            = "/oauth2/callback"
  admin_url           = "https://alertmanager.example.com"
  web_origins         = ["https://alertmanager.example.com"]
  valid_redirect_uris = ["https://alertmanager.example.com/*"]
}
```

## Audience Protocol Mapper

The module automatically creates an **audience protocol mapper** that:
- Adds the client ID to the `aud` (audience) claim in access tokens
- Ensures OAuth2 Proxy can properly validate tokens
- Named as `aud-mapper-{client_id}` for easy identification

This is essential for OAuth2 Proxy to validate that tokens are intended for the specific client.

## Prerequisites

- An existing Keycloak instance accessible from the environment
- Terraform configured with the [Keycloak provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- Sufficient permissions to manage clients and protocol mappers in the target realm
- OAuth2 Proxy deployed and configured to use Keycloak as the OIDC provider

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/) 