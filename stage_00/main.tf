locals {
  release_desc               = yamldecode(data.external.charts_versions.result.versions)
  cert_manager_chart_version = local.release_desc.charts["${var.cert_manager_chart_name}"].version
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
    chart_release = var.chorus_release
  }
}

resource "null_resource" "fetch_helm_charts_versions" {
  provisioner "local-exec" {
    quiet   = true
    command = <<EOT
      set -e
      helm_values_folder=${var.helm_values_path}/${var.cluster_name}
      output_file=${var.helm_values_path}/${var.cluster_name}/charts_versions.yaml
      chmod +x ./scripts/generate_release_desc.sh
      ./scripts/generate_release_desc.sh $helm_values_folder $output_file
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
  depends_on = [null_resource.fetch_helm_charts_values]
}

data "external" "charts_versions" {
  depends_on = [null_resource.fetch_helm_charts_versions]
  program    = ["bash", "-c", "cat ../values/${var.cluster_name}/charts_versions.yaml | yq -o json . | jq '{versions: tostring}'"]
}

resource "null_resource" "fetch_cert_manager_app_version" {
  provisioner "local-exec" {
    command = <<EOT
      set -ex
      mkdir -p ${path.module}/tmp
      helm pull "oci://${var.helm_registry}/charts/${var.cert_manager_chart_name}" --version ${local.cert_manager_chart_version} --destination ${path.module}/tmp
      tar -xzf ${path.module}/tmp/cert-manager-*.tgz -C ${path.module}/tmp
      yq -i ".charts.cert-manager.appVersion = \"$(yq '.dependencies[0].version' ${path.module}/tmp/${var.cert_manager_chart_name}/Chart.yaml)\"" ../values/${var.cluster_name}/charts_versions.yaml
      rm -r ${path.module}/tmp
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}