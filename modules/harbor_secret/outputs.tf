output "harbor_password" {
  value       = try(random_password.harbor_admin_password.result, null)
  description = "Harbor password"
  sensitive   = true
}

output "harbor_robot_secrets" {
  value = {
    for robot_name in var.harbor_robots :
    robot_name => random_password.harbor_robot_secret[robot_name].result
  }
  description = "Map of Harbor robot account names to their secrets"
  sensitive   = true
}
