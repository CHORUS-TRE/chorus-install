module "keycloak_generic_client_config" {
  source = "../keycloak_generic_client_config"

  providers = {
    keycloak = keycloak
  }

  realm_id            = var.realm_id
  client_id           = var.client_id
  client_secret       = var.client_secret
  root_url            = var.root_url
  base_url            = var.base_url
  admin_url           = var.admin_url
  web_origins         = var.web_origins
  valid_redirect_uris = var.valid_redirect_uris
}

data "keycloak_openid_client" "openid_cliend" {
  realm_id   = var.realm_id
  client_id  = var.client_id
  depends_on = [module.keycloak_generic_client_config]
}

resource "keycloak_openid_audience_protocol_mapper" "audience_mapper" {
  realm_id  = var.realm_id
  client_id = data.keycloak_openid_client.openid_cliend.id
  name      = "aud-mapper-${var.client_id}"

  included_client_audience = var.client_id
}