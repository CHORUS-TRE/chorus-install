module "keycloak_config" {
  source = "../keycloak_config"

  infra_realm_name = var.infra_realm_name
  admin_id         = var.admin_id
}

module "keycloak_realm" {
  source = "../keycloak_realm"
  realm_name = var.backend_realm_name
}
