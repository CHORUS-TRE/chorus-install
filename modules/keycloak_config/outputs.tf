output "infra_realm_id" {
  value = try(module.keycloak_realm.realm_id, null)
}