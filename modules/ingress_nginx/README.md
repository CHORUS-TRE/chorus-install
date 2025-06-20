# ingress_nginx Terraform Module

This module deploys the [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/) on a Kubernetes cluster using Terraform. It automates the installation and configuration of ingress for workloads in CHORUS-TRE environments.

## Features

- Creates a dedicated namespace for ingress-nginx
- Installs the NGINX Ingress Controller via Helm
- Waits for the LoadBalancer IP to be assigned
- Exposes the LoadBalancer IP as a Terraform output

## Outputs

| Name              | Description                                      |
|-------------------|--------------------------------------------------|
| `loadbalancer_ip` | The external IP to access the deployed services  |

## Prerequisites

- An existing Kubernetes cluster
- Helm and Kubernetes providers configured in Terraform
- Sufficient permissions to create namespaces and install cluster-wide resources

## References

- [NGINX Ingress Controller Documentation](https://kubernetes.github.io/ingress-nginx/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs) 