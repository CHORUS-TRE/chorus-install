output "infra_realm_id" {
  value = try(keycloak_realm.infra.id, null)
}