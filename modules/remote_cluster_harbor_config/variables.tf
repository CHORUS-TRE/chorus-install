variable "cluster_robot_username" {
  description = "The username of the robot account used for registry credentials"
  type        = string

  validation {
    condition     = length(var.cluster_robot_username) > 0
    error_message = "cluster_robot_username cannot be empty."
  }
}

variable "build_robot_username" {
  description = "The username of the robot account used for replication (push-based strategy)"
  type        = string
  default     = ""
}

variable "pull_replication_registry_name" {
  description = "The name of the registry to replicate from (pull-based strategy)"
  type        = string
  default     = ""
}

variable "pull_replication_registry_url" {
  description = "The URL of the registry to replicate from (pull-based strategy)"
  type        = string
  default     = ""
}