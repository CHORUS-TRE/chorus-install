locals {
  harbor_values_parsed = yamldecode(var.harbor_helm_values)
  harbor_namespace = local.harbor_values_parsed.harbor.namespace
  harbor_url = local.harbor_values_parsed.harbor.externalURL
  release_desc_parsed = yamldecode(var.release_desc)
  charts = [ for k, v in local.release_desc_parsed.charts : k ]
}

resource "harbor_project" "projects" {
  for_each = toset([ "apps", "cache", "charts", "chorus", "docker_proxy", "services" ])

  name                   = each.key
  vulnerability_scanning = "false"
  force_destroy = true
}

# ArgoCD robot account

resource "random_password" "argocd_robot_password" {
  length  = 12
  special = false
  upper   = true
  lower   = true
}

resource "harbor_robot_account" "argocd" {
  name        = var.argocd_robot_username
  description = "ArgoCD robot account"
  level       = "system"
  secret      = random_password.argocd_robot_password.result
  permissions {
    access {
      action = "list"
      resource = "project"
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
      action = "list"
      resource = "repository"
    }
    access {
      action = "list"
      resource = "tag"
    }
    access {
      action = "pull"
      resource = "repository"
    }
    access {
      action = "read"
      resource = "label"
    }
    access {
      action = "read"
      resource = "repository"
    }
    kind = "project"
    namespace = "apps"
  }
  permissions {
    access {
      action = "list"
      resource = "artifact"
    }
    access {
      action = "list"
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
      resource = "artifact"
    }
    access {
      action = "read"
      resource = "label"
    }
    access {
      action = "read"
      resource = "project"
    }
    access {
      action = "read"
      resource = "repository"
    }
    kind = "project"
    namespace = "charts"
  }

  depends_on = [ harbor_project.projects ]
}

# ArgoCI robot account

resource "random_password" "argoci_robot_password" {
  length  = 12
  special = false
  upper   = true
  lower   = true
}

resource "harbor_robot_account" "argoci" {
  name        = var.argoci_robot_username
  description = "ArgoCI robot account"
  level       = "system"
  secret      = random_password.argoci_robot_password.result
  permissions {
    access {
      action = "list"
      resource = "project"
    }
    access {
      action = "create"
      resource = "registry"
    }
    access {
      action = "list"
      resource = "registry"
    }
    access {
      action = "read"
      resource = "registry"
    }
    access {
      action = "update"
      resource = "registry"
    }
    kind = "system"
    namespace = "/"
  }
  permissions {
    access {
      action = "create"
      resource = "artifact"
    }
    access {
      action = "list"
      resource = "artifact"
    }
    access {
      action = "read"
      resource = "artifact"
    }
    access {
      action = "create"
      resource = "artifact-label"
    }
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
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "project"
    }
    access {
      action = "delete"
      resource = "repository"
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
      resource = "sbom"
    }
    access {
      action = "read"
      resource = "sbom"
    }
    access {
      action = "create"
      resource = "scan"
    }
    access {
      action = "read"
      resource = "scan"
    }
    kind = "project"
    namespace = "apps"
  }

  permissions {
    access {
      action = "create"
      resource = "artifact"
    }
    access {
      action = "list"
      resource = "artifact"
    }
    access {
      action = "read"
      resource = "artifact"
    }
    access {
      action = "create"
      resource = "artifact-label"
    }
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
      action = "list"
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "project"
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
      resource = "sbom"
    }
    access {
      action = "read"
      resource = "sbom"
    }
    access {
      action = "create"
      resource = "scanner"
    }
    access {
      action = "read"
      resource = "scanner"
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
    namespace = "docker_proxy"
  }

  permissions {
    access {
      action = "list"
      resource = "artifact"
    }
    access {
      action = "read"
      resource = "artifact"
    }
    access {
      action = "create"
      resource = "artifact-label"
    }
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
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "project"
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
      resource = "sbom"
    }
    access {
      action = "read"
      resource = "sbom"
    }
    access {
      action = "create"
      resource = "scan"
    }
    access {
      action = "read"
      resource = "scan"
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

  permissions {
    access {
      action = "list"
      resource = "artifact"
    }
    access {
      action = "read"
      resource = "artifact"
    }
    access {
      action = "create"
      resource = "artifact-label"
    }
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
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "project"
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
      resource = "sbom"
    }
    access {
      action = "read"
      resource = "sbom"
    }
    access {
      action = "create"
      resource = "scan"
    }
    access {
      action = "read"
      resource = "scan"
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
    namespace = "cache"
  }

  permissions {
    access {
      action = "create"
      resource = "artifact"
    }
    access {
      action = "list"
      resource = "artifact"
    }
    access {
      action = "read"
      resource = "artifact"
    }
    access {
      action = "create"
      resource = "artifact-label"
    }
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
      action = "list"
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "metadata"
    }
    access {
      action = "read"
      resource = "project"
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
      resource = "sbom"
    }
    access {
      action = "read"
      resource = "sbom"
    }
    access {
      action = "create"
      resource = "scan"
    }
    access {
      action = "read"
      resource = "scan"
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
    namespace = "chorus"
  }
  depends_on = [ harbor_project.projects ]
}

# Registries

resource "harbor_registry" "docker_hub" {
  provider_name = "docker-hub"
  name          = "Docker Hub"
  endpoint_url  = "https://hub.docker.com"
}

# Add Helm charts to Harbor registry

resource "null_resource" "pull_charts" {
  provisioner "local-exec" {
    quiet = true
    command = <<EOT
    set -e
    destination=${path.module}/charts
    mkdir -p $destination
    helm registry login ${var.source_helm_registry} --username=${var.source_helm_registry_username} --password=${var.source_helm_registry_password}
    charts="${join(" ", local.charts)}"
    for chart in $charts; do
      version=$(echo "${var.release_desc}" | yq ".charts.$chart.version")
      if [[ ! -f $destination/$chart-$version.tgz ]]; then
        helm pull oci://${var.source_helm_registry}/charts/$chart --version $version --destination $destination
      fi
    done
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
  depends_on = [ harbor_project.projects ]
}

resource "null_resource" "push_charts" {
  provisioner "local-exec" {
    quiet = true
    command = <<EOT
    set -e
    source=${path.module}/charts
    harbor_domain=${replace(local.harbor_url, "https://", "")}
    helm registry login $harbor_domain --username=${var.harbor_admin_username} --password=${var.harbor_admin_password} --insecure
    charts=$(find $source -type f | sort)
    for chart in $charts; do
      chart_name_version=$(basename $chart | awk -F. '{OFS="."; NF--; print}')
      chart_name=$(echo "$chart_name_version" | awk -F'-' '{for (i=1; i<NF; i++) printf $i (i<NF-1?"-":"");}')
      chart_version=$(echo "$chart_name_version" | awk -F'-' '{print $NF}')
      if ! helm show chart oci://$harbor_domain/charts/$chart_name --version $chart_version --insecure-skip-tls-verify >/dev/null 2>&1; then
        helm push $chart oci://$harbor_domain/charts --insecure-skip-tls-verify
      fi
    done
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
  depends_on = [ 
    harbor_project.projects,
    null_resource.pull_charts
 ]
}

# Container images

# TODO: discuss whether images should be built from scratch
# or if we can previously add (some of) them to a public registry

/*
resource "null_resource" "push_images" {
  provisioner "local-exec" {
    #quiet = true
    command = <<EOT
    set -e

    chmod +x ${path.module}/scripts/push_container_images.sh && \
    ${path.module}/scripts/push_container_images.sh --debug $chorus_images_revision $harbor_url $harbor_admin_username $harbor_admin_password
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
  depends_on = [ harbor_project.projects ]
}
*/

# Outputs

output "argocd_robot_password" {
  value = random_password.argocd_robot_password.result
  description = "Password of the robot user used by ArgoCD"
  sensitive = true
}

output "argoci_robot_password" {
  value = random_password.argoci_robot_password.result
  description = "Password of the robot user used by ArgoCI"
  sensitive = true
}