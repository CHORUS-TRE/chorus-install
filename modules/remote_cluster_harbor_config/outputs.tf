output "cluster_robot_password" {
  description = "Password of the robot user used by the cluster's components"
  value       = random_password.cluster_robot_password.result
  sensitive   = true
}

output "build_robot_password" {
  description = "Password of the robot user used by the Chorus build cluster (null if not created)"
  value       = try(random_password.build_robot_password[0].result, null)
  sensitive   = true
}