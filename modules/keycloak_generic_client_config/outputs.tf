output "group_id" {
  value = try(keycloak_group.openid_client_group[0].id, null)
}

output "client_id" {
  value = try(data.keycloak_openid_client.openid_client.id, null)
}