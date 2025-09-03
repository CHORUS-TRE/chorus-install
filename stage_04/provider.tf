terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.7.2"
    }
    harbor = {
      source  = "goharbor/harbor"
      version = "3.10.21"
    }
    keycloak = {
      source  = "keycloak/keycloak"
      version = "5.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.1.0"
    }
  }
  # Provider functions require Terraform 1.8 and later.
  required_version = ">= 1.8.0"
}

provider "kubernetes" {
  config_path    = var.remote_cluster_kubeconfig_path
  config_context = var.remote_cluster_kubeconfig_context
}