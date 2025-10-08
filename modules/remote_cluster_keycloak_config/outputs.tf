output "infra_realm_id" {
  description = "The ID of the infrastructure realm"
  value       = module.keycloak_config.infra_realm_id
}

output "backend_realm_id" {
  description = "The ID of the backend realm"
  value       = module.keycloak_realm.realm_id
}