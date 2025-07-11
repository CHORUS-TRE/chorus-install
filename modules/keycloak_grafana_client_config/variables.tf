variable "realm_id" {
  description = "The ID of the realm where to create the Grafana client"
  type        = string
}

variable "client_id" {
  description = "The Grafana client ID"
  type        = string
}

variable "client_secret" {
  description = "The Grafana client secret"
  type        = string
}

variable "root_url" {
  description = "The root URL of the Grafana client"
  type        = string
}

variable "base_url" {
  description = "The base URL of the Grafana client"
  type        = string
}

variable "admin_url" {
  description = "The admin URL of the Grafana client"
  type        = string
}

variable "web_origins" {
  description = "A list of allowed web origins for the Grafana client"
  type        = list(string)
}

variable "valid_redirect_uris" {
  description = "A list of valid redirect URIs for the Grafana client"
  type        = list(string)
}

variable "client_group" {
  description = "The name of the Grafana client group to create"
  type        = string
}
