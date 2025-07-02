locals {
  cert_manager_chart_version = data.external.cert_manager_config.result.version
}

resource "null_resource" "fetch_helm_charts_values" {
  provisioner "local-exec" {
    quiet   = true
    command = <<EOT
        set -e
        mkdir -p ${var.helm_values_path}/${var.helm_values_repo}
        cd ${var.helm_values_path}/${var.helm_values_repo}
        git init -q
        git remote add origin https://github.com/${var.github_orga}/${var.helm_values_repo}.git
        git fetch -q origin ${var.chorus_release}
        git sparse-checkout set ${var.cluster_name}
        git checkout -q ${var.chorus_release}
        mkdir -p ../${var.cluster_name}
        cp -r ${var.cluster_name}/* ../${var.cluster_name}
        cd ..
        rm -r ${var.helm_values_repo}
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
}

data "external" "cert_manager_config" {
  depends_on = [null_resource.fetch_helm_charts_values]
  program    = ["bash", "-c", "cat ${var.helm_values_path}/${var.cluster_name}/${var.cert_manager_chart_name}/config.json"]
}

resource "null_resource" "fetch_cert_manager_app_version" {
  provisioner "local-exec" {
    quiet   = true
    command = <<EOT
      set -e
      mkdir -p ${path.module}/tmp
      helm pull "oci://${var.helm_registry}/charts/${var.cert_manager_chart_name}" --version ${local.cert_manager_chart_version} --destination ${path.module}/tmp
      tar -xzf ${path.module}/tmp/cert-manager-*.tgz -C ${path.module}/tmp
      touch ../values/${var.cluster_name}/${var.cert_manager_chart_name}/app_version
      echo $(yq '.dependencies[0].version' ${path.module}/tmp/${var.cert_manager_chart_name}/Chart.yaml) > ../values/${var.cluster_name}/${var.cert_manager_chart_name}/app_version
      rm -r ${path.module}/tmp
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}