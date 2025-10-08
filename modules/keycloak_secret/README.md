# Keycloak Secret Terraform Module

This module generates a random password and creates a Kubernetes Secret for Keycloak admin credentials. It automates the secure generation and storage of Keycloak admin passwords in Kubernetes.

## Features

- Generates a strong random 32-character password (alphanumeric only, no special characters)
- Creates a Kubernetes Secret to store the Keycloak admin password
- Returns the generated password as a sensitive output for use in dependent modules
- Ensures consistent secret naming and key structure

## Outputs

| Name                | Description                           |
|---------------------|---------------------------------------|
| `keycloak_password` | The generated Keycloak admin password |

## Variables

| Name          | Description                                                                          | Type   | Required |
|---------------|--------------------------------------------------------------------------------------|--------|----------|
| `namespace`   | The Kubernetes namespace where Keycloak and its associated resources will be deployed| string | Yes      |
| `secret_name` | Name of the Kubernetes Secret that contains the admin credentials for the Keycloak instance | string | Yes |
| `secret_key`  | The key in the Keycloak secret that contains the admin password                      | string | Yes      |

## Usage

```hcl
module "keycloak_secret" {
  source = "../modules/keycloak_secret"

  namespace   = "keycloak"
  secret_name = "keycloak-admin-credentials"
  secret_key  = "admin-password"
}

# Use the generated password in other resources
output "admin_password" {
  value     = module.keycloak_secret.keycloak_password
  sensitive = true
}
```

## Password Generation

The module generates a random password with the following characteristics:
- **Length**: 32 characters
- **Character Set**: Alphanumeric only (a-z, A-Z, 0-9)
- **Special Characters**: Disabled (for compatibility with Keycloak)

## Secret Structure

The created Kubernetes Secret has the following structure:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: <secret_name>
  namespace: <namespace>
data:
  <secret_key>: <base64-encoded-password>
```

## Prerequisites

- An existing Kubernetes cluster with the target namespace created
- Terraform configured with:
  - [Kubernetes provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
  - [Random provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
- Sufficient permissions to create Secrets in the target namespace

## Security Considerations

- The generated password is marked as **sensitive** in Terraform outputs
- The password is stored as a Kubernetes Secret (base64-encoded)
- Ensure proper RBAC policies are in place to restrict access to the Secret
- Consider using Kubernetes encryption at rest for Secrets
- The password is randomly generated on each `terraform apply` if the resource is recreated

## References

- [Keycloak Documentation](https://www.keycloak.org/docs/latest/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
