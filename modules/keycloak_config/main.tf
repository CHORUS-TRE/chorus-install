data "keycloak_realm" "master" {
  realm = "master"
}

resource "keycloak_group" "chorus_admin" {
  realm_id = data.keycloak_realm.master.id
  name     = "CHORUS-admin"
}

data "keycloak_role" "admin" {
  realm_id = data.keycloak_realm.master.id
  name     = "admin"
}

resource "keycloak_group_roles" "chorus_admins_group_roles" {
  realm_id = data.keycloak_realm.master.id
  group_id = keycloak_group.chorus_admin.id

  role_ids = [data.keycloak_role.admin.id]
}

resource "keycloak_realm" "infra" {
  realm                       = var.infra_realm_name
  default_signature_algorithm = "RS256"
  revoke_refresh_token        = true
  refresh_token_max_reuse     = 0
  password_policy          = "length(8) and specialChars(1) and upperCase(1) and lowerCase(1) and digits(1) and notUsername and notEmail and notContainsUsername"
}

# Client scope

resource "keycloak_openid_client_scope" "groups_client_scope" {
  realm_id               = keycloak_realm.infra.id
  name                   = "groups"
  description            = "When requested, this scope will map a user's group memberships to a claim"
  include_in_token_scope = true
}

# Group membership mapper

resource "keycloak_openid_group_membership_protocol_mapper" "group_membership_mapper" {
  realm_id        = keycloak_realm.infra.id
  client_scope_id = keycloak_openid_client_scope.groups_client_scope.id
  name            = "groups"

  claim_name = "groups"
  full_path  = false
}

# User profile

resource "keycloak_realm_user_profile" "userprofile" {
  realm_id = keycloak_realm.infra.id

  attribute {
    name         = "username"
    display_name = "$${username}"

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        min = 3
        max = 8
      }
    }

    validator {
      name = "pattern"
      config = {
        pattern       = "^(?!(root|bin|daemon|adm|lp|sync|shutdown|halt|mail|news|uucp|operator|games|gopher|nobody|www-data|proxy|backup|sys|man|postfix|sshd|ftp|mysql|postgres|dnsmasq|ntp|messagebus|haldaemon|rpc|avahi|saned|usbmux|kernoops|admin|sysadmin|user|guest|test|administrator|rootuser|default|system|superuser)$)[a-z_][a-z0-9_-]*$"
        error-message = "Invalid username"
      }
    }
  }

  attribute {
    name         = "email"
    display_name = "$${email}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name   = "email"
      config = {}
    }

    validator {
      name = "length"
      config = {
        max = 255
      }
    }
  }

  attribute {
    name         = "firstName"
    display_name = "$${firstName}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        max = 255
      }
    }

    validator {
      name = "person-name-prohibited-characters"
    }
  }

  attribute {
    name         = "lastName"
    display_name = "$${lastName}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        max = 255
      }
    }

    validator {
      name = "person-name-prohibited-characters"
    }
  }
}