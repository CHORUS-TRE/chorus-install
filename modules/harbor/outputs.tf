output "harbor_db_admin_password" {
  value       = try(module.db_secret.db_admin_password, null)
  description = "Harbor DB password for Postgres user"
  sensitive   = true
}

output "harbor_db_password" {
  value       = try(module.db_secret.db_password, null)
  description = "Harbor DB password for Harbor user"
  sensitive   = true
}

output "harbor_password" {
  value       = try(module.harbor_secret.harbor_password, null)
  description = "Harbor password"
  sensitive   = true
}

output "harbor_robot_secrets" {
  value       = try(module.harbor_secret.harbor_robot_secrets, null)
  description = "Map of Harbor robot account names to their secrets"
  sensitive   = true
}
