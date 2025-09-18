module "keycloak_config" {
  source = "../keycloak_config"

  infra_realm_name = var.infra_realm_name
  admin_id         = var.admin_id

  google_identity_provider_client_id     = var.google_identity_provider_client_id
  google_identity_provider_client_secret = var.google_identity_provider_client_secret
}

module "keycloak_realm" {
  source     = "../keycloak_realm"
  realm_name = var.backend_realm_name
}
