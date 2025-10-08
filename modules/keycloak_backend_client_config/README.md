# Keycloak Backend Client Config Terraform Module

This module configures a Keycloak OpenID Connect client specifically for the CHORUS backend application. It creates and manages the backend client configuration including authentication flows, optional scopes, and access settings.

## Features

- Creates a confidential OpenID Connect client in Keycloak
- Configures authentication flows (standard flow, implicit flow, direct access grants)
- Enables OAuth2 device authorization grant
- Configures optional scopes (offline_access, groups)
- Manages valid redirect URIs and web origins
- Supports frontchannel logout

## Outputs

| Name          | Description                                    |
|---------------|------------------------------------------------|
| `client_id`   | The ID of the created Keycloak backend client |
| `client_name` | The name of the created Keycloak backend client|

## Variables

| Name                   | Description                                                    | Type         | Required |
|------------------------|----------------------------------------------------------------|--------------|----------|
| `realm_id`             | The ID of the realm where to create the Chorus backend client | string       | Yes      |
| `client_id`            | The Chorus backend client ID                                   | string       | Yes      |
| `client_secret`        | The Chorus backend client secret                               | string       | Yes      |
| `root_url`             | The root URL of the Chorus backend client                      | string       | Yes      |
| `base_url`             | The base URL of the Chorus backend client                      | string       | Yes      |
| `admin_url`            | The admin URL of the Chorus backend client                     | string       | Yes      |
| `web_origins`          | A list of allowed web origins for the Chorus backend client    | list(string) | Yes      |
| `valid_redirect_uris`  | A list of valid redirect URIs for the Chorus backend client    | list(string) | Yes      |

## Usage

```hcl
module "keycloak_backend_client_config" {
  source = "../modules/keycloak_backend_client_config"

  realm_id            = "chorus-backend"
  client_id           = "backend-client"
  client_secret       = var.backend_client_secret
  root_url            = "https://backend.example.com"
  base_url            = "/"
  admin_url           = "https://backend.example.com"
  web_origins         = ["https://backend.example.com"]
  valid_redirect_uris = ["https://backend.example.com/*"]
}
```

## Prerequisites

- An existing Keycloak instance
- Terraform configured with the [Keycloak provider](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs)
- Sufficient permissions to create clients in the target realm

## Client Configuration

The module configures the following authentication flows:
- **Standard Flow**: Enabled (Authorization Code Flow)
- **Implicit Flow**: Enabled
- **Direct Access Grants**: Enabled (Resource Owner Password Credentials)
- **Frontchannel Logout**: Enabled
- **OAuth2 Device Authorization Grant**: Enabled

### Optional Scopes

The module configures the following optional scopes:
- `offline_access` - For obtaining refresh tokens
- `groups` - For including group membership in tokens

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs)
- [OpenID Connect Specification](https://openid.net/specs/openid-connect-core-1_0.html)
