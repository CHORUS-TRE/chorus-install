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

  registration_allowed     = true
  login_with_email_allowed = true
}

# User profile

resource "keycloak_realm_user_profile" "userprofile" {
  realm_id = keycloak_realm.backend.id
  #unmanaged_attribute_policy = "ENABLED"

  attribute {
    name = "username"
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
        pattern = "^(?!(root|bin|daemon|adm|lp|sync|shutdown|halt|mail|news|uucp|operator|games|gopher|nobody|www-data|proxy|backup|sys|man|postfix|sshd|ftp|mysql|postgres|dnsmasq|ntp|messagebus|haldaemon|rpc|avahi|saned|usbmux|kernoops|admin|sysadmin|user|guest|test|administrator|rootuser|default|system|superuser)$)[a-z_][a-z0-9_-]*$"
        error-message = "Invalid username"
      }
    }
  }

  attribute {
    name = "email"
    display_name = "$${email}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "email"
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
    name = "firstName"
    display_name = "$${firstName}"
    
    enabled_when_scope = ["*"]
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
    name = "lastName"
    display_name = "$${lastName}"
    
    enabled_when_scope = ["*"]
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


# Password policy

# TODO
