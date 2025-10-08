variable "realm_id" {
  description = "The ID of the realm where to create the Chorus backend client"
  type        = string

  validation {
    condition     = length(var.realm_id) > 0
    error_message = "realm_id cannot be empty."
  }
}

variable "client_id" {
  description = "The Chorus backend client ID"
  type        = string

  validation {
    condition     = length(var.client_id) > 0
    error_message = "client_id cannot be empty."
  }
}

variable "client_secret" {
  description = "The Chorus backend client secret"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.client_secret) > 0
    error_message = "client_secret cannot be empty."
  }
}

variable "root_url" {
  description = "The root URL of the Chorus backend client"
  type        = string

  validation {
    condition     = length(var.root_url) > 0
    error_message = "root_url cannot be empty."
  }
}

variable "base_url" {
  description = "The base URL of the Chorus backend client"
  type        = string

  validation {
    condition     = length(var.base_url) > 0
    error_message = "base_url cannot be empty."
  }
}

variable "admin_url" {
  description = "The admin URL of the Chorus backend client"
  type        = string

  validation {
    condition     = length(var.admin_url) > 0
    error_message = "admin_url cannot be empty."
  }
}

variable "web_origins" {
  description = "A list of allowed web origins for the Chorus backend client"
  type        = list(string)

  validation {
    condition     = length(var.web_origins) > 0
    error_message = "web_origins must contain at least one origin."
  }
}

variable "valid_redirect_uris" {
  description = "A list of valid redirect URIs for the Chorus backend client"
  type        = list(string)

  validation {
    condition     = length(var.valid_redirect_uris) > 0
    error_message = "valid_redirect_uris must contain at least one URI."
  }
}
