output "realm_id" {
  description = "The ID of the created Keycloak realm"
  value       = keycloak_realm.new_realm.id
}