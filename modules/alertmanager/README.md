# alertmanager Terraform Module

This module configures [Prometheus Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/) integrations on a Kubernetes cluster using Terraform.  
It automates the management of sensitive secrets for Webex-based alerting in CHORUS-TRE.

## Features

- Manages Webex integration secrets

## Prerequisites

- An existing Kubernetes cluster with kube-prometheus-stack installed
- Sufficient permissions to create secrets in the specified namespace
- A valid Webex bot access token (for Webex notifications)

## Example Usage

```hcl
module "alertmanager" {
  source = "./modules/alertmanager"

  alertmanager_namespace = "prometheus"
  webex_secret_name      = "config-webex-secret"
  webex_access_token     = "your-access-token"
}
```