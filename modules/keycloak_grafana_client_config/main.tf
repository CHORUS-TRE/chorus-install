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
  client_group        = var.client_group
}

resource "keycloak_group" "grafana_editors_group" {
  realm_id  = var.realm_id
  parent_id = module.keycloak_generic_client_config.group_id
  name      = "Editors"
}

resource "keycloak_group" "grafana_admins_group" {
  realm_id  = var.realm_id
  parent_id = keycloak_group.grafana_editors_group.id
  name      = "Administrators"
}

resource "keycloak_role" "grafana_admin" {
  realm_id  = var.realm_id
  client_id = module.client_id
  name      = "admin"

  depends_on = [module.keycloak_generic_client_config]
}

resource "keycloak_role" "grafana_editor" {
  realm_id  = var.realm_id
  client_id = module.client_id
  name      = "editor"

  depends_on = [module.keycloak_generic_client_config]
}

resource "keycloak_group_roles" "grafana_editors_group_roles" {
  realm_id = var.realm_id
  group_id = keycloak_group.grafana_editors_group.id

  role_ids = [keycloak_role.grafana_editor.id]
}

resource "keycloak_group_roles" "grafana_admins_group_roles" {
  realm_id = var.realm_id
  group_id = keycloak_group.grafana_admins_group.id

  role_ids = [keycloak_role.grafana_admin.id]
}