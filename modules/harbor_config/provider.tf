terraform {
  required_providers {
    harbor = {
      source  = "goharbor/harbor"
      version = "3.10.21"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
  # Provider functions require Terraform 1.8 and later.
  required_version = ">= 1.8.0"
}