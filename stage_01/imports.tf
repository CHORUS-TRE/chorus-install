locals {
  namespaces_to_import = {
    ingress_nginx_namespace = {
      object_id = local.ingress_nginx_namespace
      attach_to = "module.ingress_nginx.kubernetes_namespace.ingress_nginx"
    }
    cert_manager_namespace = {
      object_id = local.cert_manager_namespace
      attach_to = "module.cert_manager.kubernetes_namespace.cert_manager"
    }
    keycloak_namespace = {
      object_id = local.keycloak_namespace
      attach_to = "module.keycloak.kubernetes_namespace.keycloak"
    }
    harbor_namespace = {
      object_id = local.harbor_namespace
      attach_to = "module.harbor.kubernetes_namespace.harbor"
    }
  }

  secrets_to_import = {
    keycloak_db_secret = {
      object_id = local.keycloak_db_secret_name
      attach_to = "module.keycloak.kubernetes_secret.keycloak_db_secret"
      namespace = local.keycloak_namespace
    }
    keycloak_secret = {
      object_id = local.keycloak_secret_name
      attach_to = "module.keycloak.kubernetes_secret.keycloak_secret"
      namespace = local.keycloak_namespace
    }
    harbor_db_secret = {
      object_id = local.harbor_db_secret_name
      attach_to = "module.harbor.kubernetes_secret.harbor_db_secret"
      namespace = local.harbor_namespace
    }
    harbor_secret = {
      object_id = local.harbor_secret_name
      attach_to = "module.harbor.kubernetes_secret.harbor_secret"
      namespace = local.harbor_namespace
    }
    harbor_encryption_key_secret = {
      object_id = local.harbor_encryption_key_secret_name
      attach_to = "module.harbor.kubernetes_secret.harbor_encryption_key_secret"
      namespace = local.harbor_namespace
    }
    harbor_xsrf_secret = {
      object_id = local.harbor_xsrf_secret_name
      attach_to = "module.harbor.kubernetes_secret.harbor_xsrf_secret"
      namespace = local.harbor_namespace
    }
    harbor_admin_secret = {
      object_id = local.harbor_admin_secret_name
      attach_to = "module.harbor.kubernetes_secret.harbor_admin_secret"
      namespace = local.harbor_namespace
    }
    harbor_jobservice_secret = {
      object_id = local.harbor_jobservice_secret_name
      attach_to = "module.harbor.kubernetes_secret.harbor_jobservice_secret"
      namespace = local.harbor_namespace
    }
    harbor_registry_http_secret = {
      object_id = local.harbor_registry_http_secret_name
      attach_to = "module.harbor.kubernetes_secret.harbor_registry_http_secret"
      namespace = local.harbor_namespace
    }
    harbor_registry_credentials_secret = {
      object_id = local.harbor_registry_credentials_secret_name
      attach_to = "module.harbor.kubernetes_secret.harbor_registry_credentials_secret"
      namespace = local.harbor_namespace
    }
  }
}

resource "null_resource" "cond_import_namespaces" {
  for_each = local.namespaces_to_import

  provisioner "local-exec" {
    quiet       = true
    command     = "chmod +x ${path.module}/../scripts/conditional_import.sh && ${path.module}/../scripts/conditional_import.sh $OBJECT_TYPE $OBJECT_ID $ATTACH_TO"
    interpreter = ["/bin/sh", "-c"]
    environment = {
      KUBECONFIG  = pathexpand(var.kubeconfig_path)
      OBJECT_TYPE = "namespace"
      OBJECT_ID   = each.value.object_id
      ATTACH_TO   = each.value.attach_to
    }
  }

  triggers = {
    object_id = each.value.object_id
  }
}

resource "null_resource" "cond_import_secrets" {
  for_each = local.secrets_to_import

  provisioner "local-exec" {
    quiet       = true
    command     = "chmod +x ${path.module}/../scripts/conditional_import.sh && ${path.module}/../scripts/conditional_import.sh $OBJECT_TYPE $OBJECT_ID $ATTACH_TO"
    interpreter = ["/bin/sh", "-c"]
    environment = {
      KUBECONFIG  = pathexpand(var.kubeconfig_path)
      OBJECT_TYPE = "secret"
      OBJECT_ID   = each.value.object_id
      ATTACH_TO   = each.value.attach_to
      NAMESPACE   = each.value.namespace
    }
  }

  triggers = {
    object_id = each.value.object_id
  }

  depends_on = [null_resource.cond_import_namespaces]
}
