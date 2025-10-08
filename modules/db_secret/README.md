# Database Secret Module

This module generates random passwords for database users and stores them in a Kubernetes Secret.

## Purpose

Creates a Kubernetes Secret containing randomly generated passwords for:
- Database admin user
- Database regular user

The module is designed to be reused across multiple database deployments (PostgreSQL, etc.) in the CHORUS-TRE infrastructure.

## Features

- Generates secure random passwords (32 characters, alphanumeric only)
- Creates a single Kubernetes Secret with configurable key names
- Exposes generated passwords as outputs for use in database configurations
- Flexible key naming to support different database implementations

## Usage

```hcl
module "db_secret" {
  source = "../modules/db_secret"

  namespace           = "my-namespace"
  secret_name         = "postgresql-credentials"
  db_user_secret_key  = "password"
  db_admin_secret_key = "postgres-password"
}
```

## Requirements

- Terraform >= 1.8.0
- Kubernetes provider >= 2.36.0
- Random provider >= 3.7.2

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `secret_name` | The name of the Kubernetes Secret that contains the database credentials | `string` | Yes |
| `namespace` | The Kubernetes namespace where the secret will be created | `string` | Yes |
| `db_admin_secret_key` | The key name within the secret that stores the database admin password | `string` | Yes |
| `db_user_secret_key` | The key name within the secret that stores the database user password | `string` | Yes |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `db_password` | Generated password for the database user | Yes |
| `db_admin_password` | Generated password for the database admin user | Yes |

## Password Specifications

- **Length**: 32 characters
- **Character Set**: Alphanumeric only (no special characters)
- **Generation**: Uses Terraform's random provider for cryptographically secure passwords

## Examples

### Keycloak Database Secret

```hcl
module "keycloak_db_secret" {
  source = "../modules/db_secret"

  namespace           = "keycloak"
  secret_name         = "keycloak-postgresql"
  db_user_secret_key  = "password"
  db_admin_secret_key = "postgres-password"
}
```

### Harbor Database Secret

```hcl
module "harbor_db_secret" {
  source = "../modules/db_secret"

  namespace           = "harbor"
  secret_name         = "harbor-postgresql"
  db_user_secret_key  = "password"
  db_admin_secret_key = "postgres-password"
}
```

## Notes

- The generated passwords are stored in Terraform state - ensure state is properly secured
- Passwords are marked as sensitive in outputs to prevent accidental logging
- The module creates only the secret - database deployment is handled separately
- Both passwords use the same specification (length/character set) for consistency
