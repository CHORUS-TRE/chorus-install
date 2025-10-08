# remote_cluster_keycloak_config Terraform Module

This module configures Keycloak for a remote cluster in the CHORUS-TRE multi-cluster setup. It creates two separate realms (infrastructure and backend) with appropriate configurations, including optional Google Identity Provider integration.

## Features

- Creates an infrastructure realm using the `keycloak_config` module
- Creates a backend realm using the `keycloak_realm` module
- Configures Google Identity Provider for both realms (optional)
- Sets up realm-specific configurations for CHORUS-TRE remote cluster deployments
- Returns realm IDs for use in dependent configurations

## Outputs

| Name               | Description                          |
|--------------------|--------------------------------------|
| `infra_realm_id`   | The ID of the infrastructure realm   |
| `backend_realm_id` | The ID of the backend realm          |

## Variables

| Name                                       | Description                                          | Type   | Required | Default |
|--------------------------------------------|------------------------------------------------------|--------|----------|---------|
| `admin_id`                                 | Keycloak admin ID                                    | string | Yes      | -       |
| `infra_realm_name`                         | Keycloak infrastructure realm name                   | string | Yes      | -       |
| `backend_realm_name`                       | Keycloak chorus backend realm name                   | string | Yes      | -       |
| `google_identity_provider_client_id`       | The Google client identifier                         | string | No       | ""      |
| `google_identity_provider_client_secret`   | The Google client secret used for authentication     | string | No       | ""      |

## Usage

```hcl
module "remote_cluster_keycloak_config" {
  source = "../modules/remote_cluster_keycloak_config"

  admin_id           = "admin"
  infra_realm_name   = "chorus-infra"
  backend_realm_name = "chorus-backend"

  # Optional: Configure Google Identity Provider
  google_identity_provider_client_id     = var.google_client_id
  google_identity_provider_client_secret = var.google_client_secret
}
```

## Realm Configuration

### Infrastructure Realm

Created using the `keycloak_config` module, which provides:
- Master realm configuration with CHORUS-admin group
- Infrastructure realm with:
  - Custom `groups` client scope
  - Group membership protocol mapper
  - Optional Google Identity Provider integration
  - Security best practices (RS256, refresh token policies)

### Backend Realm

Created using the `keycloak_realm` module, which provides:
- Dedicated realm for CHORUS backend applications
- Strong password policy requirements
- User registration and email-based login
- Comprehensive user profile validation:
  - Username validation (3-8 chars, lowercase, prohibited system names)
  - Email validation (format and length)
  - First name and last name validation

## Multi-Cluster Architecture

This module is specifically designed for **remote cluster** deployments in a multi-cluster CHORUS-TRE setup:

- **Infrastructure Realm**: Used by cluster infrastructure components (Grafana, Harbor, etc.)
- **Backend Realm**: Used by CHORUS backend application and frontend

The separation of realms provides:
- **Isolation**: Different security domains for infrastructure vs. application
- **Flexibility**: Independent configuration and policies per realm
- **Security**: Reduced blast radius in case of compromise

## Google Identity Provider

When `google_identity_provider_client_id` and `google_identity_provider_client_secret` are provided:
- Google Identity Provider is configured for the **master realm** with refresh token support
- Google Identity Provider is configured for the **infrastructure realm** with email trust
- Users can authenticate using their Google accounts
- SSO integration for improved user experience

## Prerequisites

- An existing Keycloak instance accessible from the environment
- Terraform configured with the [Keycloak provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- Sufficient permissions to create and manage realms, groups, and identity providers in Keycloak
- (Optional) Google OAuth credentials for identity provider integration

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- [Google Identity Platform](https://developers.google.com/identity)
