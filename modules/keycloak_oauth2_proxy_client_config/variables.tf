variable "realm_id" {
  description = "The ID of the realm where to create the client"
  type        = string
}

variable "client_id" {
  description = "The client ID"
  type        = string
}

variable "client_secret" {
  description = "The client secret"
  type        = string
}

variable "root_url" {
  description = "The root URL of the client"
  type        = string
}

variable "base_url" {
  description = "The base URL of the client"
  type        = string
}

variable "admin_url" {
  description = "The admin URL of the client"
  type        = string
}

variable "web_origins" {
  description = "A list of allowed web origins for the client"
  type        = list(string)
}

variable "valid_redirect_uris" {
  description = "A list of valid redirect URIs for the client"
  type        = list(string)
}