# Harbor Secret Module

This module generates and manages all required Kubernetes Secrets for a Harbor container registry deployment.

## Purpose

Creates all necessary secrets for Harbor's operation, including:
- Core Harbor secrets (encryption, XSRF protection)
- Admin credentials
- Registry authentication (HTTP and htpasswd-based)
- Job service secrets
- OIDC authentication configuration

## Features

- Generates cryptographically secure random passwords for all Harbor components
- Creates bcrypt-hashed htpasswd credentials for registry authentication
- Manages OIDC configuration secrets for Keycloak integration
- Uses appropriate password lengths based on Harbor requirements (16 or 32 characters)
- Follows Harbor Helm chart requirements for hardcoded secret keys

## Usage

```hcl
module "harbor_secret" {
  source = "../modules/harbor_secret"

  namespace                        = "harbor"
  core_secret_name                 = "harbor-core"
  encryption_key_secret_name       = "harbor-encryption-key"
  xsrf_secret_name                 = "harbor-xsrf"
  xsrf_secret_key                  = "key"
  admin_username                   = "admin"
  admin_secret_name                = "harbor-admin"
  admin_secret_key                 = "password"
  jobservice_secret_name           = "harbor-jobservice"
  jobservice_secret_key            = "secret"
  registry_secret_name             = "harbor-registry-http"
  registry_secret_key              = "secret"
  registry_credentials_secret_name = "harbor-registry-credentials"
  oidc_secret_name                 = "harbor-oidc"
  oidc_secret_key                  = "client-secret"
  oidc_config                      = jsonencode({
    client_id     = "harbor"
    client_secret = "secret-value"
    endpoint      = "https://keycloak.example.com"
  })
}
```

## Requirements

- Terraform >= 1.8.0
- Kubernetes provider >= 2.36.0
- Random provider >= 3.7.2
- HTPasswd provider >= 1.2.1

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `namespace` | The Kubernetes namespace where Harbor is deployed | `string` | Yes |
| `core_secret_name` | Name of the Kubernetes Secret for core Harbor secrets | `string` | Yes |
| `admin_username` | The username of the Harbor admin | `string` | Yes |
| `admin_secret_name` | Name of the Kubernetes Secret for Harbor admin password | `string` | Yes |
| `admin_secret_key` | Key in the admin password secret | `string` | Yes |
| `encryption_key_secret_name` | Name of the Kubernetes Secret for encryption key | `string` | Yes |
| `xsrf_secret_name` | Name of the Kubernetes Secret for XSRF protection | `string` | Yes |
| `xsrf_secret_key` | Key in the XSRF protection secret | `string` | Yes |
| `jobservice_secret_name` | Name of the Kubernetes Secret for jobservice | `string` | Yes |
| `jobservice_secret_key` | Key in the jobservice secret | `string` | Yes |
| `registry_secret_name` | Name of the Kubernetes Secret for registry HTTP secret | `string` | Yes |
| `registry_secret_key` | Key in the registry HTTP secret | `string` | Yes |
| `registry_credentials_secret_name` | Name of the Kubernetes Secret for registry credentials | `string` | Yes |
| `oidc_secret_name` | Name of the Kubernetes Secret for OIDC configuration | `string` | Yes |
| `oidc_secret_key` | Key in the OIDC secret | `string` | Yes |
| `oidc_config` | OIDC configuration in JSON format | `string` | Yes |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `harbor_password` | Generated Harbor admin password | Yes |

## Secrets Created

The module creates 8 Kubernetes Secrets:

1. **Core Secret** (`core_secret_name`)
   - Key: `secret` (hardcoded per Harbor Helm chart)
   - Value: 16-character random password

2. **Encryption Key Secret** (`encryption_key_secret_name`)
   - Key: `secretKey` (hardcoded per Harbor Helm chart)
   - Value: 16-character random password

3. **XSRF Secret** (`xsrf_secret_name`)
   - Key: Configurable via `xsrf_secret_key`
   - Value: 32-character random password

4. **Admin Password Secret** (`admin_secret_name`)
   - Key: Configurable via `admin_secret_key`
   - Value: 32-character random password

5. **Job Service Secret** (`jobservice_secret_name`)
   - Key: Configurable via `jobservice_secret_key`
   - Value: 16-character random password

6. **Registry HTTP Secret** (`registry_secret_name`)
   - Key: Configurable via `registry_secret_key`
   - Value: 16-character random password

7. **Registry Credentials Secret** (`registry_credentials_secret_name`)
   - Keys: `REGISTRY_PASSWD`, `REGISTRY_HTPASSWD` (hardcoded per Harbor Helm chart)
   - Values: Password and bcrypt htpasswd hash

8. **OIDC Secret** (`oidc_secret_name`)
   - Key: Configurable via `oidc_secret_key`
   - Value: OIDC configuration (JSON)

## Password Specifications

- **16-character passwords**: Used for Harbor internal components (core, encryption, jobservice, registry HTTP)
- **32-character passwords**: Used for admin and XSRF protection
- **All passwords**: Alphanumeric only (no special characters)
- **HTPasswd**: Uses bcrypt with random 8-character salt

## Notes

- Some secret keys are hardcoded to match Harbor Helm chart requirements
- The htpasswd provider generates bcrypt hashes for registry authentication
- All passwords are stored in Terraform state - ensure state is properly secured
- OIDC config should be valid JSON for Keycloak integration
- The module is designed to work with the Harbor Helm chart's expected secret structure
