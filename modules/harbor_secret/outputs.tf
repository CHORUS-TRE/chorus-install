output "harbor_password" {
  value       = try(random_password.harbor_admin_password.result, null)
  description = "Harbor password"
  sensitive   = true
}