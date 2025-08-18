module "keycloak_generic_client_config" {
  source = "../keycloak_generic_client_config"

  realm_id            = var.realm_id
  client_id           = var.client_id
  client_secret       = var.client_secret
  root_url            = var.root_url
  base_url            = var.base_url
  admin_url           = var.admin_url
  web_origins         = var.web_origins
  valid_redirect_uris = var.valid_redirect_uris
}

resource "keycloak_group" "backend_uma_protection" {
  realm_id  = var.realm_id
  parent_id = module.keycloak_generic_client_config.group_id
  name      = "uma_protection"
}