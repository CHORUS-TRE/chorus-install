output "cluster_robot_password" {
  value       = try(random_password.cluster_robot_password.result, null)
  description = "Password of the robot user used by the cluster's components"
  sensitive   = true
}

output "build_robot_password" {
  value       = try(random_password.build_robot_password[0].result, null)
  description = "Password of the robot user used by the Chorus build cluster"
  sensitive   = true
}