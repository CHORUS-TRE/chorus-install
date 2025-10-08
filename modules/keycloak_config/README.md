# keycloak_config Terraform Module

This module configures [Keycloak](https://www.keycloak.org/) realms, groups, identity providers, and client scopes using Terraform. It automates the setup of the master realm admin group, infrastructure realm, Google identity providers, and custom OIDC scopes for CHORUS-TRE.

## Features

- Configures the Keycloak master realm with admin group and roles
- Creates a custom infrastructure realm via the `keycloak_realm` submodule
- Optionally configures Google Identity Provider for both master and infrastructure realms
- Creates custom OpenID client scope for group membership mapping
- Configures group membership protocol mapper for token claims

## Outputs

| Name              | Description                           |
|-------------------|---------------------------------------|
| `infra_realm_id`  | The ID of the infrastructure realm    |

## Variables

| Name                                       | Description                                          | Type   | Required | Default |
|--------------------------------------------|------------------------------------------------------|--------|----------|---------|
| `admin_id`                                 | Keycloak admin ID                                    | string | Yes      | -       |
| `infra_realm_name`                         | Keycloak infrastructure realm name                   | string | Yes      | -       |
| `google_identity_provider_client_id`       | The Google client identifier                         | string | No       | ""      |
| `google_identity_provider_client_secret`   | The Google client secret used for authentication     | string | No       | ""      |

## Usage

```hcl
module "keycloak_config" {
  source = "../modules/keycloak_config"

  admin_id         = "admin"
  infra_realm_name = "chorus-infra"

  # Optional: Configure Google Identity Provider
  google_identity_provider_client_id     = var.google_client_id
  google_identity_provider_client_secret = var.google_client_secret
}
```

## Realm Configuration

### Master Realm
- Creates `CHORUS-admin` group
- Assigns `admin` role to the CHORUS-admin group
- Optionally configures Google Identity Provider with refresh token support

### Infrastructure Realm
- Creates a new realm with the specified name
- Optionally configures Google Identity Provider with email trust
- Creates `groups` client scope for group membership claims
- Configures group membership protocol mapper

## Client Scopes

The module creates a custom `groups` client scope that:
- Maps user group memberships to token claims
- Uses the claim name `groups`
- Does not include full path (only group names)
- Can be used as an optional scope by OIDC clients

## Prerequisites

- An existing Keycloak instance accessible from the environment
- Terraform configured with the [Keycloak provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- Sufficient permissions to manage realms, clients, groups, and identity providers
- (Optional) Google OAuth credentials for identity provider integration

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- [Google Identity Platform](https://developers.google.com/identity) 