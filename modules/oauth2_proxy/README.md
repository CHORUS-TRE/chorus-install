# oauth2_proxy Terraform Module

This module manages the deployment and secret management for OAuth2 Proxy instances (e.g. for Prometheus, Alertmanager) in a Kubernetes cluster using Terraform. It automates the creation of required Kubernetes secrets and enforces configuration consistency for secure authentication and session storage in CHORUS-TRE.

## Features

- Validates and enforces that Prometheus and Alertmanager OAuth2 Proxy secrets are consistent
- Creates Kubernetes secrets for OIDC and session storage for Prometheus and Alertmanager OAuth2 Proxy deployments
- Supports custom Helm values for each OAuth2 Proxy instance
- Ensures proper resource dependencies and readiness

## Prerequisites

- An existing Kubernetes cluster
- Kubernetes provider configured in Terraform
- Sufficient permissions to create namespaces and secrets
- Helm releases for Prometheus, Alertmanager OAuth2 Proxy and Valkey should reference the secrets created by this module

## References

- [OAuth2 Proxy Documentation](https://oauth2-proxy.github.io/oauth2-proxy/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
