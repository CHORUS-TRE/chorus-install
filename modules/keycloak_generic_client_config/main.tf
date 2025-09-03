resource "keycloak_openid_client" "openid_client" {
  realm_id      = var.realm_id
  client_id     = var.client_id
  name          = title(var.client_id)
  client_secret = var.client_secret
  enabled       = true
  access_type   = "CONFIDENTIAL"

  root_url            = var.root_url
  base_url            = var.base_url
  admin_url           = var.admin_url
  web_origins         = var.web_origins
  valid_redirect_uris = var.valid_redirect_uris

  standard_flow_enabled        = true
  implicit_flow_enabled        = true
  direct_access_grants_enabled = true
  frontchannel_logout_enabled  = true
}

resource "keycloak_group" "openid_client_group" {
  realm_id = var.realm_id
  name     = var.client_group

  count = var.client_group == null ? 0 : 1
}

data "keycloak_openid_client" "openid_client" {
  realm_id   = var.realm_id
  client_id  = var.client_id
  depends_on = [keycloak_openid_client.openid_client]
}

resource "keycloak_openid_client_optional_scopes" "client_optional_scopes" {
  realm_id  = var.realm_id
  client_id = data.keycloak_openid_client.openid_client.id

  optional_scopes = [
    "offline_access",
    "groups"
  ]
}