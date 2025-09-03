variable "secret_name" {
  type        = string
  description = "The name of the Kubernetes Secret that contains the database credentials"
}

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where the secret will be created or referenced"
}

variable "db_admin_secret_key" {
  type        = string
  description = "The key name within the secret that stores the database admin password"
}

variable "db_user_secret_key" {
  type        = string
  description = "The key name within the secret that stores the database user password"
}