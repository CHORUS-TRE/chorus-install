output "group_id" {
  value = try(keycloak_group.openid_client_group[0].id, null)
}