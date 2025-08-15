locals {
  # CHORUS uses its own versioning system
  # such that
  # cert_manager_chart_version != cert_manager_app_version
  cert_manager_chart_version = data.external.cert_manager_config.result.version
  cert_manager_app_version   = data.external.cert_manager_app_version.result.version
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

# In the official Jetstack Helm chart,
# the cert-manager release tag corresponds
# to the app version
data "external" "cert_manager_app_version" {
  program = [
    "/bin/sh", "-c",
    <<EOT
      set -e
      tmp_dir="${path.module}/tmp"
      mkdir -p "$tmp_dir"
      echo ${var.helm_registry_password} | helm registry login ${var.helm_registry} -u ${var.helm_registry_username} --password-stdin
      helm pull "oci://${var.helm_registry}/charts/${var.cert_manager_chart_name}" --version ${local.cert_manager_chart_version} --destination "$tmp_dir"
      tar -xzf "$tmp_dir"/cert-manager-*.tgz -C "$tmp_dir"
      version=$(yq '.dependencies[0].version' "$tmp_dir/${var.cert_manager_chart_name}/Chart.yaml")
      rm -rf "$tmp_dir"
      echo "{\"version\": \"$version\"}"
    EOT
  ]
}

data "http" "cert_manager_crds" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/${local.cert_manager_app_version}/cert-manager.crds.yaml"
}

resource "local_file" "cert_manager_crds" {
  filename = "${path.module}/${var.cert_manager_crds_path}"
  content  = data.http.cert_manager_crds.response_body
}