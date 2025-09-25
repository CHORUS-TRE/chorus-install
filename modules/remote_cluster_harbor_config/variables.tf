variable "cluster_robot_username" {
  description = "The username of the robot account used for registry credentials"
  type        = string
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