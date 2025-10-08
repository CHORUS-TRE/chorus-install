# keycloak_generic_client_config Terraform Module

This module provisions a generic OpenID client in a Keycloak realm using Terraform. It is designed to be reusable for any application that requires an OpenID Connect client configuration in Keycloak.

## Features

- Provisions a Keycloak OpenID client with confidential access
- Configures root, base, and admin URLs
- Sets allowed web origins and valid redirect URIs
- Optionally creates a client group for the client
- Configures standard flow, implicit flow, and direct access grants
- Enables frontchannel logout
- Adds optional scopes (offline_access, groups)

## Outputs

| Name        | Description                                 |
|-------------|---------------------------------------------|
| `group_id`  | The ID of the created client group (if any) |
| `client_id` | The ID of the created OpenID client         |

## Variables

| Name                   | Description                                      | Type         | Required | Default |
|------------------------|--------------------------------------------------|--------------|----------|---------|
| `realm_id`             | The ID of the realm where to create the client   | string       | Yes      | -       |
| `client_id`            | The client ID for the OpenID client              | string       | Yes      | -       |
| `client_secret`        | The client secret for the OpenID client          | string       | Yes      | -       |
| `root_url`             | The root URL of the client                       | string       | Yes      | -       |
| `base_url`             | The base URL of the client                       | string       | Yes      | -       |
| `admin_url`            | The admin URL of the client                      | string       | Yes      | -       |
| `web_origins`          | A list of allowed web origins                    | list(string) | Yes      | -       |
| `valid_redirect_uris`  | A list of valid redirect URIs                    | list(string) | Yes      | -       |
| `client_group`         | The name of the client group to create (optional)| string       | No       | null    |

## Usage

```hcl
module "keycloak_harbor_client_config" {
  source = "../modules/keycloak_generic_client_config"

  realm_id            = "chorus-infra"
  client_id           = "harbor-client"
  client_secret       = var.harbor_client_secret
  root_url            = "https://harbor.example.com"
  base_url            = "/harbor/projects"
  admin_url           = "https://harbor.example.com"
  web_origins         = ["https://harbor.example.com"]
  valid_redirect_uris = ["https://harbor.example.com/c/oidc/callback"]
  client_group        = "harbor-admins"  # Optional
}
```

## Client Configuration

The module configures the following authentication flows:
- **Standard Flow**: Enabled (Authorization Code Flow)
- **Implicit Flow**: Enabled
- **Direct Access Grants**: Enabled (Resource Owner Password Credentials)
- **Frontchannel Logout**: Enabled

### Optional Scopes

The module configures the following optional scopes:
- `offline_access` - For obtaining refresh tokens
- `groups` - For including group membership in tokens

## Prerequisites

- An existing Keycloak instance accessible from the environment
- Terraform configured with the [Keycloak provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- Sufficient permissions to manage clients and groups in the target realm

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- [OpenID Connect Specification](https://openid.net/specs/openid-connect-core-1_0.html) 