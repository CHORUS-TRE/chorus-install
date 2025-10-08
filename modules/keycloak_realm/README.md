# Keycloak Realm Terraform Module

This module creates and configures a Keycloak realm with security best practices and comprehensive user profile validation. It sets up a realm with strong password policies, user registration, and detailed user attribute validation.

## Features

- Creates a new Keycloak realm with secure defaults
- Configures RS256 signature algorithm for tokens
- Implements strong password policy requirements
- Enables user registration and email-based login
- Configures refresh token security (revocation and no reuse)
- Sets up comprehensive user profile with validation:
  - Username validation (length, pattern, prohibited usernames)
  - Email validation (format and length)
  - First name and last name validation (length and character restrictions)

## Outputs

| Name       | Description                         |
|------------|-------------------------------------|
| `realm_id` | The ID of the created Keycloak realm|

## Variables

| Name         | Description                    | Type   | Required |
|--------------|--------------------------------|--------|----------|
| `realm_name` | Name of the realm to create    | string | Yes      |

## Usage

```hcl
module "keycloak_realm" {
  source = "../modules/keycloak_realm"

  realm_name = "chorus-infra"
}
```

## Realm Configuration

### Security Settings

- **Signature Algorithm**: RS256 (recommended for production)
- **Refresh Token Security**:
  - Revoke refresh tokens enabled
  - Max reuse count: 0 (prevents token reuse)

### Password Policy

The module enforces a strong password policy requiring:
- Minimum length: 8 characters
- At least 1 special character
- At least 1 uppercase letter
- At least 1 lowercase letter
- At least 1 digit
- Cannot be the username
- Cannot be the email address
- Cannot contain the username

### User Registration

- **Registration**: Enabled (allows self-registration)
- **Login with Email**: Enabled (users can log in with email or username)

## User Profile Attributes

### Username

- **Display Name**: `${username}`
- **Permissions**: Viewable and editable by admin and user
- **Validations**:
  - Length: 3-8 characters
  - Pattern: Must be lowercase with optional numbers, hyphens, or underscores
  - Prohibited: Common system usernames (root, admin, etc.) are blocked

**Prohibited Usernames**: root, bin, daemon, adm, lp, sync, shutdown, halt, mail, news, uucp, operator, games, gopher, nobody, www-data, proxy, backup, sys, man, postfix, sshd, ftp, mysql, postgres, dnsmasq, ntp, messagebus, haldaemon, rpc, avahi, saned, usbmux, kernoops, admin, sysadmin, user, guest, test, administrator, rootuser, default, system, superuser

### Email

- **Display Name**: `${email}`
- **Required**: For users with 'user' role
- **Permissions**: Viewable and editable by admin and user
- **Validations**:
  - Must be valid email format
  - Maximum length: 255 characters

### First Name

- **Display Name**: `${firstName}`
- **Required**: For users with 'user' role
- **Permissions**: Viewable and editable by admin and user
- **Validations**:
  - Maximum length: 255 characters
  - No prohibited characters for person names

### Last Name

- **Display Name**: `${lastName}`
- **Required**: For users with 'user' role
- **Permissions**: Viewable and editable by admin and user
- **Validations**:
  - Maximum length: 255 characters
  - No prohibited characters for person names

## Prerequisites

- An existing Keycloak instance accessible from the environment
- Terraform configured with the [Keycloak provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
- Sufficient permissions to create and manage realms in Keycloak

## References

- [Keycloak Realm Documentation](https://www.keycloak.org/docs/latest/server_admin/#configuring-realms)
- [Keycloak User Profile](https://www.keycloak.org/docs/latest/server_admin/#user-profile)
- [Terraform Keycloak Provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs)
