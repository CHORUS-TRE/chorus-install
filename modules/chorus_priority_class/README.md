# chorus_priority_class Terraform Module

This module deploys CHORUS Priority Class resources on a Kubernetes cluster using Terraform. It automates the installation of priority classes for managing pod scheduling priorities in CHORUS-TRE environments.

## Features

- Installs CHORUS Priority Class via Helm chart from an OCI registry
- Configures priority classes in the default namespace
- Uses default priority class values from the Helm chart
- Supports cluster-specific naming conventions

## Variables

| Name               | Description                                      | Type   | Required |
|--------------------|--------------------------------------------------|--------|----------|
| `cluster_name`     | Cluster name used as prefix for release names    | string | Yes      |
| `helm_registry`    | Helm chart registry to get the chart from        | string | Yes      |
| `chart_name`       | Priority Class Helm chart name                   | string | Yes      |
| `chart_version`    | Priority Class Helm chart version                | string | Yes      |
| `kubeconfig_path`  | Path to the Kubernetes config file               | string | Yes      |

## Prerequisites

- An existing Kubernetes cluster
- Helm and Kubernetes providers configured in Terraform
- Access to an OCI-compatible Helm registry containing the priority class chart
- Sufficient permissions to create priority class resources

## References

- [Kubernetes Priority Classes](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
