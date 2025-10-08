variable "cluster_name" {
  description = "The cluster name to be used as a prefix to release names"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "cluster_name cannot be empty."
  }
}

variable "helm_registry" {
  description = "Helm chart registry to get the chart from"
  type        = string

  validation {
    condition     = length(var.helm_registry) > 0
    error_message = "helm_registry cannot be empty."
  }
}

variable "harbor_chart_name" {
  description = "Harbor Helm chart name"
  type        = string

  validation {
    condition     = length(var.harbor_chart_name) > 0
    error_message = "harbor_chart_name cannot be empty."
  }
}

variable "harbor_chart_version" {
  description = "Harbor Helm chart version"
  type        = string

  validation {
    condition     = length(var.harbor_chart_version) > 0
    error_message = "harbor_chart_version cannot be empty."
  }
}

variable "harbor_helm_values" {
  description = "Harbor Helm chart values"
  type        = string

  validation {
    condition     = length(var.harbor_helm_values) > 0
    error_message = "harbor_helm_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.harbor_helm_values))
    error_message = "harbor_helm_values must be valid YAML."
  }
}

variable "harbor_namespace" {
  description = "Namespace to deploy Harbor Helm chart into"
  type        = string

  validation {
    condition     = length(var.harbor_namespace) > 0
    error_message = "harbor_namespace cannot be empty."
  }
}

variable "harbor_cache_chart_name" {
  description = "Harbor cache (e.g. Valkey) Helm chart name"
  type        = string

  validation {
    condition     = length(var.harbor_cache_chart_name) > 0
    error_message = "harbor_cache_chart_name cannot be empty."
  }
}

variable "harbor_cache_chart_version" {
  description = "Harbor cache (e.g. Valkey) Helm chart version"
  type        = string

  validation {
    condition     = length(var.harbor_cache_chart_version) > 0
    error_message = "harbor_cache_chart_version cannot be empty."
  }
}

variable "harbor_cache_helm_values" {
  description = "Harbor cache (e.g. Valkey) Helm chart values"
  type        = string

  validation {
    condition     = length(var.harbor_cache_helm_values) > 0
    error_message = "harbor_cache_helm_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.harbor_cache_helm_values))
    error_message = "harbor_cache_helm_values must be valid YAML."
  }
}

variable "harbor_db_chart_name" {
  description = "Harbor DB (e.g. PostgreSQL) Helm chart name"
  type        = string

  validation {
    condition     = length(var.harbor_db_chart_name) > 0
    error_message = "harbor_db_chart_name cannot be empty."
  }
}

variable "harbor_db_chart_version" {
  description = "Harbor DB (e.g. PostgreSQL) Helm chart version"
  type        = string

  validation {
    condition     = length(var.harbor_db_chart_version) > 0
    error_message = "harbor_db_chart_version cannot be empty."
  }
}

variable "harbor_db_helm_values" {
  description = "Harbor DB Helm chart values (e.g. PostgreSQL)"
  type        = string

  validation {
    condition     = length(var.harbor_db_helm_values) > 0
    error_message = "harbor_db_helm_values cannot be empty."
  }

  validation {
    condition     = can(yamldecode(var.harbor_db_helm_values))
    error_message = "harbor_db_helm_values must be valid YAML."
  }
}

variable "harbor_db_secret_name" {
  description = "Name of the Kubernetes Secret containing Harbor database credentials"
  type        = string

  validation {
    condition     = length(var.harbor_db_secret_name) > 0
    error_message = "harbor_db_secret_name cannot be empty."
  }
}

variable "harbor_db_user_secret_key" {
  description = "Key within the Harbor database secret that stores the database user password"
  type        = string

  validation {
    condition     = length(var.harbor_db_user_secret_key) > 0
    error_message = "harbor_db_user_secret_key cannot be empty."
  }
}

variable "harbor_db_admin_secret_key" {
  description = "Key within the Harbor database secret that stores the database admin password"
  type        = string

  validation {
    condition     = length(var.harbor_db_admin_secret_key) > 0
    error_message = "harbor_db_admin_secret_key cannot be empty."
  }
}

variable "harbor_core_secret_name" {
  description = "Name of the Kubernetes Secret used for general Harbor credentials"
  type        = string

  validation {
    condition     = length(var.harbor_core_secret_name) > 0
    error_message = "harbor_core_secret_name cannot be empty."
  }
}

variable "harbor_encryption_key_secret_name" {
  description = "Name of the Kubernetes Secret containing the Harbor encryption key"
  type        = string

  validation {
    condition     = length(var.harbor_encryption_key_secret_name) > 0
    error_message = "harbor_encryption_key_secret_name cannot be empty."
  }
}

variable "harbor_xsrf_secret_name" {
  description = "Name of the Kubernetes Secret containing the Harbor XSRF token"
  type        = string

  validation {
    condition     = length(var.harbor_xsrf_secret_name) > 0
    error_message = "harbor_xsrf_secret_name cannot be empty."
  }
}

variable "harbor_xsrf_secret_key" {
  description = "Key within the Harbor XSRF secret that stores the XSRF token"
  type        = string

  validation {
    condition     = length(var.harbor_xsrf_secret_key) > 0
    error_message = "harbor_xsrf_secret_key cannot be empty."
  }
}

variable "harbor_admin_username" {
  description = "Harbor admin username"
  type        = string

  validation {
    condition     = length(var.harbor_admin_username) > 0
    error_message = "harbor_admin_username cannot be empty."
  }
}

variable "harbor_admin_secret_name" {
  description = "Name of the Kubernetes Secret containing Harbor admin account credentials"
  type        = string

  validation {
    condition     = length(var.harbor_admin_secret_name) > 0
    error_message = "harbor_admin_secret_name cannot be empty."
  }
}

variable "harbor_admin_secret_key" {
  description = "Key within the Harbor admin secret that contains the admin password"
  type        = string

  validation {
    condition     = length(var.harbor_admin_secret_key) > 0
    error_message = "harbor_admin_secret_key cannot be empty."
  }
}

variable "harbor_jobservice_secret_name" {
  description = "Name of the Kubernetes Secret containing credentials for the Harbor job service"
  type        = string

  validation {
    condition     = length(var.harbor_jobservice_secret_name) > 0
    error_message = "harbor_jobservice_secret_name cannot be empty."
  }
}

variable "harbor_jobservice_secret_key" {
  description = "Key within the Harbor job service secret containing the required credential"
  type        = string

  validation {
    condition     = length(var.harbor_jobservice_secret_key) > 0
    error_message = "harbor_jobservice_secret_key cannot be empty."
  }
}

variable "harbor_registry_http_secret_name" {
  description = "Name of the Kubernetes Secret containing Harbor registry HTTP authentication credentials"
  type        = string

  validation {
    condition     = length(var.harbor_registry_http_secret_name) > 0
    error_message = "harbor_registry_http_secret_name cannot be empty."
  }
}

variable "harbor_registry_http_secret_key" {
  description = "Key within the Harbor registry HTTP secret containing the authentication token or password"
  type        = string

  validation {
    condition     = length(var.harbor_registry_http_secret_key) > 0
    error_message = "harbor_registry_http_secret_key cannot be empty."
  }
}

variable "harbor_registry_credentials_secret_name" {
  description = "Name of the Kubernetes Secret containing Harbor registry access credentials"
  type        = string

  validation {
    condition     = length(var.harbor_registry_credentials_secret_name) > 0
    error_message = "harbor_registry_credentials_secret_name cannot be empty."
  }
}

variable "harbor_oidc_secret_name" {
  description = "Name of the Kubernetes Secret containing the Harbor OIDC configuration"
  type        = string

  validation {
    condition     = length(var.harbor_oidc_secret_name) > 0
    error_message = "harbor_oidc_secret_name cannot be empty."
  }
}

variable "harbor_oidc_secret_key" {
  description = "Key within the Harbor OIDC secret containing the configuration"
  type        = string

  validation {
    condition     = length(var.harbor_oidc_secret_key) > 0
    error_message = "harbor_oidc_secret_key cannot be empty."
  }
}

variable "harbor_oidc_config" {
  description = "OIDC configuration settings for Harbor"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.harbor_oidc_config) > 0
    error_message = "harbor_oidc_config cannot be empty."
  }

  validation {
    condition     = can(jsondecode(var.harbor_oidc_config))
    error_message = "harbor_oidc_config must be valid JSON."
  }
}