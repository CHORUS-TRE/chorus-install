output "db_password" {
  description = "Generated password for the database user"
  value       = random_password.db_password.result
  sensitive   = true
}

output "db_admin_password" {
  description = "Generated password for the database admin user"
  value       = random_password.db_admin_password.result
  sensitive   = true
}