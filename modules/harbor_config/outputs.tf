output "github_actions_robot_password" {
  value       = random_password.github_actions_robot_password.result
  description = "Password of the robot user used by GitHub Actions"
  sensitive   = true
}

output "argocd_robot_password" {
  value       = random_password.argocd_robot_password.result
  description = "Password of the robot user used by ArgoCD"
  sensitive   = true
}

output "argoci_robot_password" {
  value       = random_password.argoci_robot_password.result
  description = "Password of the robot user used by ArgoCI"
  sensitive   = true
}

output "renovate_robot_password" {
  value       = random_password.renovate_robot_password.result
  description = "Password of the robot user used by Renovate"
  sensitive   = true
}