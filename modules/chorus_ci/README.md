# chorus_ci Terraform Module

This module provisions Kubernetes secrets used by Chorus CI. These secrets are designed to securely store credentials for various GitHub repositories that Chorus CI interacts with, such as for Workbench Operator, Chorus Web UI, Images, and Chorus Backend.

## Features

- Creates Kubernetes `Secret` resources for GitHub Personal Access Tokens (PATs).
- Securely stores sensitive GitHub tokens in the specified namespace.
- Supports token management for multiple GitHub repositories used by Argo CI workflows.

## Prerequisites

- An existing Kubernetes cluster.
- Kubernetes provider configured in Terraform.
- Sufficient permissions to create `Secret` resources in the target namespace.
- The ArgoCD namespace (where these secrets will reside) must exist.

## References

- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
