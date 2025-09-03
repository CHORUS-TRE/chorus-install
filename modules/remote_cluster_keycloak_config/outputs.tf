output "infra_realm_id" {
  value = try(module.keycloak_config.infra_realm_id, null)
}

output "backend_realm_id" {
  value = try(module.keycloak_realm.realm_id, null)
}