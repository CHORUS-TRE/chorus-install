variable "secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret that contains the database credentials"

  validation {
    condition     = length(var.secret_name) > 0
    error_message = "secret_name cannot be empty."
  }
}

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where the secret will be created or referenced"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "namespace cannot be empty."
  }
}

variable "db_admin_secret_key" {
  type        = string
  description = "The key name within the secret that stores the database admin password"

  validation {
    condition     = length(var.db_admin_secret_key) > 0
    error_message = "db_admin_secret_key cannot be empty."
  }
}

variable "db_user_secret_key" {
  type        = string
  description = "The key name within the secret that stores the database user password"

  validation {
    condition     = length(var.db_user_secret_key) > 0
    error_message = "db_user_secret_key cannot be empty."
  }
}