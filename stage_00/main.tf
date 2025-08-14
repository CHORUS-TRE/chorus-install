locals {
  # CHORUS uses its own versioning system
  # such that
  # cert_manager_chart_version != cert_manager_app_version
  cert_manager_chart_version = data.external.cert_manager_config.result.version
  cert_manager_app_version = data.external.cert_manager_app_version.result.version
}

resource "null_resource" "fetch_helm_charts_values" {
  provisioner "local-exec" {
    quiet       = true
    command     = <<EOT
        set -e
        mkdir -p ${var.helm_values_path}/${var.helm_values_repo}
        cd ${var.helm_values_path}/${var.helm_values_repo}
        git init -q
        pat=${coalesce(var.helm_values_pat, "public")}
        if [ "$pat" = "public" ]; then
          git remote add origin https://github.com/${var.github_orga}/${var.helm_values_repo}.git
        else
          git remote add origin https://${var.github_orga}:$pat@github.com/${var.github_orga}/${var.helm_values_repo}.git
        fi
        git fetch -q origin ${var.chorus_release}
        git sparse-checkout set ${var.cluster_name}
        git checkout -q ${var.chorus_release}
        mkdir -p ../${var.cluster_name}
        cp -r ${var.cluster_name}/* ../${var.cluster_name}
        cd ..
        rm -r ${var.helm_values_repo}
    EOT
    interpreter = ["/bin/sh", "-c"]
  }
  triggers = {
    always_run = timestamp()
  }
}

data "external" "cert_manager_config" {
  depends_on = [null_resource.fetch_helm_charts_values]
  program    = ["/bin/cat", "${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/config.json"]
}

resource "null_resource" "fetch_cert_manager_app_version" {
  provisioner "local-exec" {
    quiet       = true
    command     = <<EOT
      set -e
      mkdir -p ${path.module}/tmp
      helm registry login ${var.helm_registry} -u ${var.helm_registry_username} -p ${var.helm_registry_password}
      helm pull "oci://${var.helm_registry}/charts/${var.cert_manager_chart_name}" --version ${local.cert_manager_chart_version} --destination ${path.module}/tmp
      tar -xzf ${path.module}/tmp/cert-manager-*.tgz -C ${path.module}/tmp
      touch ${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/app_version
      printf '%s' $(yq '.dependencies[0].version' ${path.module}/tmp/${var.cert_manager_chart_name}/Chart.yaml) > ${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/app_version
      rm -r ${path.module}/tmp
    EOT
    interpreter = ["/bin/sh", "-c"]
  }

  triggers = {
    always_run = timestamp()
  }
}

data "external" "cert_manager_app_version" {
  program = [
    "/bin/sh", "-c",
    <<EOT
      set -e
      helm registry login ${var.helm_registry} -u ${var.helm_registry_username} -p ${var.helm_registry_password} >/dev/null
      helm pull "oci://${var.helm_registry}/charts/${var.cert_manager_chart_name}" --version ${local.cert_manager_chart_version} --destination /tmp
      tar -xzf /tmp/cert-manager-*.tgz -C /tmp
      version=$(yq '.dependencies[0].version' /tmp/${var.cert_manager_chart_name}/Chart.yaml)
      rm -rf /tmp/cert-manager*
      echo "{\"version\": \"${version}\"}"
    EOT
  ]
}

data "http" "cert_manager_crds" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/${var.cert_manager_app_version}/cert-manager.crds.yaml"
}

resource "local_file" "cert_manager_crds" {
  filename = "${path.module}/${var.cert_manager_crds_path}"
  content  = data.http.cert_manager_crds.response_body
}

output "cert_manager_crds_path" {
  value = local_file.cert_manager_crds.filename
}