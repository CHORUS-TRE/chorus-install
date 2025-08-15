variable "cert_manager_crds_path" {
  description = "Path to the file containing the cert-manager CRDs"
  type        = string
}

variable "keycloak_namespace" {
  description = "Namespace where Keycloak is deployed"
  type        = string
}

variable "keycloak_secret_name" {
  description = "Name of the Kubernetes secret containing the Keycloak admin credentials"
  type        = string
}

variable "keycloak_secret_key" {
  description = "Key within the Keycloak secret that stores the admin password"
  type        = string
}

variable "keycloak_db_secret_name" {
  description = "Name of the Kubernetes secret containing Keycloak database credentials"
  type        = string
}

variable "keycloak_db_admin_secret_key" {
  description = "Key within the Keycloak database secret that stores the admin password"
  type        = string
}

variable "keycloak_db_user_secret_key" {
  description = "Key within the Keycloak database secret that stores the user password"
  type        = string
}

variable "harbor_namespace" {
  description = "Namespace where Harbor is deployed"
  type        = string
}

variable "harbor_secret_name" {
  description = "Name of the Kubernetes secret containing the Harbor admin credentials"
  type        = string
}

variable "harbor_secret_key" {
  description = "Key within the Harbor secret that stores the admin password"
  type        = string
}

variable "harbor_db_secret_name" {
  description = "Name of the Kubernetes secret containing Harbor database credentials"
  type        = string
}

variable "harbor_db_admin_secret_key" {
  description = "Key within the Harbor database secret that stores the admin password"
  type        = string
}

variable "harbor_db_user_secret_key" {
  description = "Key within the Harbor database secret that stores the user password"
  type        = string
}

variable "harbor_encryption_key_secret_name" {
  description = "Name of the Kubernetes secret containing the Harbor encryption key"
  type        = string
}

variable "harbor_xsrf_secret_name" {
  description = "Name of the Kubernetes secret containing the Harbor XSRF protection key"
  type        = string
}

variable "harbor_xsrf_secret_key" {
  description = "Key within the Harbor XSRF secret that stores the CSRF key"
  type        = string
}

variable "harbor_admin_secret_name" {
  description = "Name of the Kubernetes secret containing Harbor admin password for configuration purposes"
  type        = string
}

variable "harbor_admin_secret_key" {
  description = "Key within the Harbor admin secret that stores the admin password"
  type        = string
}

variable "harbor_jobservice_secret_name" {
  description = "Name of the Kubernetes secret containing Harbor Jobservice credentials"
  type        = string
}

variable "harbor_jobservice_secret_key" {
  description = "Key within the Harbor Jobservice secret that stores the jobservice secret"
  type        = string
}

variable "harbor_registry_http_secret_name" {
  description = "Name of the Kubernetes secret containing Harbor registry HTTP credentials"
  type        = string
}

variable "harbor_registry_http_secret_key" {
  description = "Key within the Harbor registry HTTP secret that stores the registry HTTP secret"
  type        = string
}

variable "harbor_registry_credentials_secret_name" {
  description = "Name of the Kubernetes secret containing Harbor registry credentials"
  type        = string
}

variable "harbor_oidc_secret_name" {
  description = "Name of the Kubernetes secret containing Harbor OIDC configuration"
  type        = string
}

variable "harbor_oidc_secret_key" {
  description = "Key within the Harbor OIDC secret that stores the configuration JSON"
  type        = string
}

variable "harbor_oidc_config" {
  description = "JSON configuration for Harbor OIDC authentication"
  type        = string
}