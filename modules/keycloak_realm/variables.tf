variable "realm_name" {
  description = "Name of the realm to create"
  type        = string

  validation {
    condition     = length(var.realm_name) > 0
    error_message = "realm_name cannot be empty."
  }
}