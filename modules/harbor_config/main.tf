locals {
  harbor_values_parsed = yamldecode(var.harbor_helm_values)
  harbor_url           = local.harbor_values_parsed.harbor.externalURL
  charts               = [for k, v in var.charts_versions : k]
}

# Registries

resource "harbor_registry" "docker_hub" {
  provider_name = "docker-hub"
  name          = "Docker Hub"
  endpoint_url  = "https://hub.docker.com"
}

# Projects

resource "harbor_project" "projects" {
  for_each = toset(["apps", "cache", "charts", "chorus", "docker_proxy", "services"])

  name                   = each.key
  vulnerability_scanning = "false"
  force_destroy          = true
}

# Proxy cache projects

resource "harbor_project" "proxy_cache" {
  name = "docker_proxy"
  registry_id = harbor_registry.docker_hub.id
}

# GitHub Actions robot account

resource "random_password" "github_actions_robot_password" {
  length      = 32
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "harbor_robot_account" "github_actions" {
  name        = var.github_actions_robot_username
  description = "Robot used by GitHub Actions to automatically publish new Helm charts"
  level       = "project"
  secret      = random_password.github_actions_robot_password.result
  permissions {
    access {
      action = "create"
      resource = "label"
    }
    access {
      action = "list"
      resource = "label"
    }
    access {
      action = "read"
      resource = "label"
    }
    access {
      action = "update"
      resource = "label"
    }
    access {
      action = "list"
      resource = "repository"
    }
    access {
      action = "pull"
      resource = "repository"
    }
    access {
      action = "push"
      resource = "repository"
    }
    access {
      action = "read"
      resource = "repository"
    }
    access {
      action = "update"
      resource = "repository"
    }
    access {
      action = "create"
      resource = "tag"
    }
    access {
      action = "list"
      resource = "tag"
    }

    kind = "project"
    namespace = "charts"
  }

  depends_on = [harbor_project.projects]
}

# ArgoCD robot account

resource "random_password" "argocd_robot_password" {
  length      = 32
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "harbor_robot_account" "argocd" {
  name        = var.argocd_robot_username
  description = "ArgoCD robot account"
  level       = "system"
  secret      = random_password.argocd_robot_password.result
  permissions {
    access {
      action   = "list"
      resource = "project"
    }
    kind      = "system"
    namespace = "/"
  }
  permissions {
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "list"
      resource = "tag"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    kind      = "project"
    namespace = "apps"
  }
  permissions {
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    kind      = "project"
    namespace = "charts"
  }

  depends_on = [harbor_project.projects]
}

# ArgoCI robot account

resource "random_password" "argoci_robot_password" {
  length      = 32
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "harbor_robot_account" "argoci" {
  name        = var.argoci_robot_username
  description = "ArgoCI robot account"
  level       = "system"
  secret      = random_password.argoci_robot_password.result
  permissions {
    access {
      action   = "list"
      resource = "project"
    }
    access {
      action   = "create"
      resource = "registry"
    }
    access {
      action   = "list"
      resource = "registry"
    }
    access {
      action   = "read"
      resource = "registry"
    }
    access {
      action   = "update"
      resource = "registry"
    }
    kind      = "system"
    namespace = "/"
  }
  permissions {
    access {
      action   = "create"
      resource = "artifact"
    }
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "create"
      resource = "artifact-label"
    }
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "update"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "delete"
      resource = "repository"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    access {
      action   = "update"
      resource = "repository"
    }
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "create"
      resource = "scan"
    }
    access {
      action   = "read"
      resource = "scan"
    }
    kind      = "project"
    namespace = "apps"
  }

  permissions {
    access {
      action   = "create"
      resource = "artifact"
    }
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "create"
      resource = "artifact-label"
    }
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    access {
      action   = "update"
      resource = "repository"
    }
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "create"
      resource = "scanner"
    }
    access {
      action   = "read"
      resource = "scanner"
    }
    access {
      action   = "create"
      resource = "tag"
    }
    access {
      action   = "list"
      resource = "tag"
    }
    kind      = "project"
    namespace = "docker_proxy"
  }

  permissions {
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "create"
      resource = "artifact-label"
    }
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "update"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    access {
      action   = "update"
      resource = "repository"
    }
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "create"
      resource = "scan"
    }
    access {
      action   = "read"
      resource = "scan"
    }
    access {
      action   = "create"
      resource = "tag"
    }
    access {
      action   = "list"
      resource = "tag"
    }
    kind      = "project"
    namespace = "charts"
  }

  permissions {
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "create"
      resource = "artifact-label"
    }
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "update"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    access {
      action   = "update"
      resource = "repository"
    }
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "create"
      resource = "scan"
    }
    access {
      action   = "read"
      resource = "scan"
    }
    access {
      action   = "create"
      resource = "tag"
    }
    access {
      action   = "list"
      resource = "tag"
    }
    kind      = "project"
    namespace = "cache"
  }

  permissions {
    access {
      action   = "create"
      resource = "artifact"
    }
    access {
      action   = "list"
      resource = "artifact"
    }
    access {
      action   = "read"
      resource = "artifact"
    }
    access {
      action   = "create"
      resource = "artifact-label"
    }
    access {
      action   = "create"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "label"
    }
    access {
      action   = "read"
      resource = "label"
    }
    access {
      action   = "list"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "metadata"
    }
    access {
      action   = "read"
      resource = "project"
    }
    access {
      action   = "list"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "read"
      resource = "repository"
    }
    access {
      action   = "update"
      resource = "repository"
    }
    access {
      action   = "create"
      resource = "sbom"
    }
    access {
      action   = "read"
      resource = "sbom"
    }
    access {
      action   = "create"
      resource = "scan"
    }
    access {
      action   = "read"
      resource = "scan"
    }
    access {
      action   = "create"
      resource = "tag"
    }
    access {
      action   = "list"
      resource = "tag"
    }
    kind      = "project"
    namespace = "chorus"
  }
  depends_on = [harbor_project.projects]
}

# ArgoCI robot account

resource "random_password" "renovate_robot_password" {
  length      = 32
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "harbor_robot_account" "renovate" {
  name        = var.renovate_robot_username
  description = "Renovate robot account"
  level       = "system"
  secret      = random_password.renovate_robot_password.result
  permissions {
    access {
      action = "list"
      resource = "project"
    }
    access {
      action = "list"
      resource = "registry"
    }
    access {
      action = "read"
      resource = "registry"
    }
    kind = "system"
    namespace = "/"
  }
  permissions {
    access {
      action = "list"
      resource = "label"
    }
    access {
      action = "read"
      resource = "label"
    }
    access {
      action = "list"
      resource = "repository"
    }
    access {
      action = "pull"
      resource = "repository"
    }
    access {
      action = "read"
      resource = "repository"
    }
    access {
      action = "list"
      resource = "tag"
    }
    kind = "project"
    namespace = "charts"
  }
  permissions {
    access {
      action = "list"
      resource = "label"
    }
    access {
      action = "read"
      resource = "label"
    }
    access {
      action = "list"
      resource = "repository"
    }
    access {
      action = "pull"
      resource = "repository"
    }
    access {
      action = "read"
      resource = "repository"
    }
    access {
      action = "list"
      resource = "tag"
    }
    kind = "project"
    namespace = "docker_proxy"
  }
  depends_on = [
    harbor_project.projects,
    harbor_project.proxy_cache
  ]
}

# Add Helm charts to Harbor registry

resource "null_resource" "pull_charts" {
  provisioner "local-exec" {
    quiet   = true
    command = <<EOT
    set -e
    destination=${path.module}/charts
    chart=${each.key}
    versions="${join(" ", each.value)}"
    mkdir -p $destination
    for version in $versions; do
      helm registry login ${var.source_helm_registry} --username=${var.source_helm_registry_username} --password=${var.source_helm_registry_password}
      if [ ! -f "$destination/$chart-$version.tgz" ]; then
        helm pull oci://${var.source_helm_registry}/charts/$chart --version $version --destination $destination
      fi
    done
    EOT
  }
  for_each = var.charts_versions

  triggers = {
    always_run = timestamp()
  }

  depends_on = [harbor_project.projects]
}

resource "null_resource" "push_charts" {
  provisioner "local-exec" {
    quiet   = true
    command = <<EOT
    set -e
    source=${path.module}/charts
    harbor_domain=${replace(local.harbor_url, "https://", "")}
    helm registry login $harbor_domain --username=${var.harbor_admin_username} --password=${var.harbor_admin_password} --insecure
    chart=${each.key}
    versions="${join(" ", each.value)}"
    for version in $versions; do
      if ! helm show chart oci://$harbor_domain/charts/$chart --version $version --insecure-skip-tls-verify >/dev/null 2>&1; then
        helm push $source/$chart-$version.tgz oci://$harbor_domain/charts --insecure-skip-tls-verify
      fi
    done
    EOT
  }
  for_each = var.charts_versions

  triggers = {
    always_run = timestamp()
  }

  depends_on = [
    harbor_project.projects,
    null_resource.pull_charts
  ]
}