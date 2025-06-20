resource "null_resource" "fetch_helm_charts_versions" {
  provisioner "local-exec" {
    quiet = true
    command = <<EOT
      set -e
      charts_folder=${var.helm_charts_path}/${var.helm_charts_repo}/charts
      output_file=${var.helm_charts_path}/${var.helm_charts_revision}.yaml
      mkdir -p $charts_folder
      cd $charts_folder
      git init -q
      git remote add origin https://github.com/${var.github_orga}/${var.helm_charts_repo}.git
      git fetch --tags
      git fetch -q origin ${var.helm_charts_revision}
      git sparse-checkout set charts
      git checkout -q ${var.helm_charts_revision}
      cd -
      chmod +x ./scripts/generate_charts_version_file.sh
      ./scripts/generate_charts_version_file.sh $charts_folder $output_file
      rm -r $charts_folder
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
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
        git fetch -q origin ${var.helm_values_revision}
        git sparse-checkout set ${var.cluster_name}
        git checkout -q ${var.helm_values_revision}
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