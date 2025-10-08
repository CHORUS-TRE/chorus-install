output "client_id" {
  description = "The ID of the created Keycloak client"
  value       = module.keycloak_generic_client_config.client_id
}

output "audience_mapper_id" {
  description = "The ID of the audience protocol mapper"
  value       = keycloak_openid_audience_protocol_mapper.audience_mapper.id
}
