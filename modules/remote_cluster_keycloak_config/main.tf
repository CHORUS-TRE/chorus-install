module "keycloak_config" {
  source = "../keycloak_config"

  infra_realm_name = var.infra_realm_name
  admin_id         = var.admin_id
}

resource "keycloak_realm" "backend" {
  realm                       = var.backend_realm_name
  default_signature_algorithm = "RS256"
  revoke_refresh_token        = true
  refresh_token_max_reuse     = 0
}