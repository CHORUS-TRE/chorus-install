output "client_id" {
  description = "The ID of the created Grafana Keycloak client"
  value       = module.keycloak_generic_client_config.client_id
}

output "editors_group_id" {
  description = "The ID of the Grafana Editors group"
  value       = keycloak_group.grafana_editors_group.id
}

output "admins_group_id" {
  description = "The ID of the Grafana Administrators group"
  value       = keycloak_group.grafana_admins_group.id
}

output "admin_role_id" {
  description = "The ID of the Grafana admin role"
  value       = keycloak_role.grafana_admin.id
}

output "editor_role_id" {
  description = "The ID of the Grafana editor role"
  value       = keycloak_role.grafana_editor.id
}
