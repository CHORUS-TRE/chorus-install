variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where Keycloak and its associated resources will be deployed"
}

variable "secret_name" {
  type        = string
  description = "Name of the Kubernetes Secret that contains the admin credentials for the Keycloak instance."
}

variable "secret_key" {
  type        = string
  description = "The key in the Keycloak secret that contains the admin password."
}