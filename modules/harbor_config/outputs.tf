output "github_actions_robot_password" {
  value       = try(random_password.github_actions_robot_password.result, null)
  description = "Password of the robot user used by GitHub Actions"
  sensitive   = true
}

output "argocd_robot_password" {
  value       = try(random_password.argocd_robot_password.result, null)
  description = "Password of the robot user used by ArgoCD"
  sensitive   = true
}

output "chorusci_robot_password" {
  value       = try(random_password.chorusci_robot_password.result, null)
  description = "Password of the robot user used by ChorusCI"
  sensitive   = true
}

output "renovate_robot_password" {
  value       = try(random_password.renovate_robot_password.result, null)
  description = "Password of the robot user used by Renovate"
  sensitive   = true
}