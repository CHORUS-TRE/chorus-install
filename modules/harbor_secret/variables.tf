variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where Harbor is deployed"
}

variable "core_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret that contains the core secrets for Harbor"
}

variable "admin_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret that contains the Harbor admin password"
}

variable "admin_secret_key" {
  type        = string
  description = "The key in the Harbor admin password secret that stores the actual admin password"
}

variable "encryption_key_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret that contains the encryption key"
}

variable "xsrf_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing the XSRF protection secret for Harbor"
}

variable "xsrf_secret_key" {
  type        = string
  description = "The key in the XSRF protection secret that stores the actual token"
}

variable "jobservice_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing the jobservice secret for Harbor's internal communication"
}

variable "jobservice_secret_key" {
  type        = string
  description = "The key in the jobservice secret that stores the actual jobservice secret"
}

variable "registry_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing the HTTP secret used by the Harbor registry"
}

variable "registry_secret_key" {
  type        = string
  description = "The key within the Harbor registry HTTP secret that holds the shared HTTP secret"
}

variable "registry_credentials_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing Harbor registry credentials"
}

variable "oidc_secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret containing the OIDC secret for Harbor authentication"
}

variable "oidc_secret_key" {
  type        = string
  description = "The key in the OIDC secret that contains the OIDC client secret for Harbor authentication"
}

variable "oidc_config" {
  type        = string
  description = "A string containing the OIDC configuration in JSON format for Harbor integration"
}

variable "harbor_admin_username" {
  description = "Harbor admin username"
  type        = string
}