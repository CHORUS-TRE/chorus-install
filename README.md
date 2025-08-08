# CHORUS-TRE Installation

## Table of contents
<!-- Generated with VIM plugin https://github.com/mzlogin/vim-markdown-toc -->

<!-- vim-markdown-toc GFM -->

* [Prerequisites](#prerequisites)
    * [Local machine tools](#local-machine-tools)
    * [Infrastructure](#infrastructure)
    * [Repositories](#repositories)
* [Install](#install)
* [Uninstall](#uninstall)
* [License and Usage Restrictions](#license-and-usage-restrictions)

<!-- vim-markdown-toc -->

## Prerequisites

### Local machine tools

| Tool                                                          | Description                                                                                                                                                                                                      |
| ------------------------------------------------------------------ | ---------------------------------------------------- |
| [git](https://git-scm.com/downloads)                               | Git is required to clone this repository             |
| [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl)  | Kubernetes command-line tool kubectl is required to run commands against Kubernetes clusters                                                                                                                    |
| [helm 3](https://github.com/helm/helm#install)                     | Helm Charts are used to package Kubernetes resources for each component |
| [terraform](https://developer.hashicorp.com/terraform/install)                     | Terraform is used to automate the installation |
| [yq](https://mikefarah.gitbook.io/yq#install)                     | yq is a lightweight and portable command-line YAML processor |
<!--
| [argocd cli](https://argo-cd.readthedocs.io/en/stable/cli_installation)                     | ArgoCD CLI is required to manage the CHORUS-TRE ArgoCD instance |
| [argo cli](https://argo-workflows.readthedocs.io/en/stable/walk-through/argo-cli/)                            | Argo-Workflows CLI is required to manage CI jobs |
-->

### Infrastructure

| Component          | Description                                                                                                        | Required |
| ------------------ | ------------------------------------------------------------------------------------------------------------------ | -------- |
| Kubernetes cluster | An infrastructure with a working Kubernetes cluster | Required |
| Domain name        | CHORUS-TRE is only accessible via HTTPS and it's essential to register a domain name via registrars like Cloudflare, Route53, etc. | Required |  
| DNS Server         | CHORUS-TRE is only accessible via HTTPS and it's essential to have a DNS server via providers like Cloudflare, Route53, etc.                  | Required |

### Repositories

| Repository                                                          | Description                                                                                                                                                                                                      |
| ------------------------------------------------------------------ | ---------------------------------------------------- |
| [environment-template](https://github.com/CHORUS-TRE/environment-template)                               | Repository gathering all the Helm charts values files             |

## Install

1. Set variables for your usecase

    ```
    cp .env.example .env
    ```

    Edit this file as needed.

1. Source your env file
    ```
    source .env
    ```

1. Initialize, plan and apply stage 0

    ```
    cd stage_00
    terraform login
    terraform workspace show
    terraform init
    terraform plan -out="stage_00.plan"
    terraform apply "stage_00.plan"
    ```

1. Initialize, plan and apply stage 1

    ```
    cd ../stage_01
    terraform login
    terraform workspace show
    terraform init
    terraform plan -out="stage_01.plan"
    terraform apply "stage_01.plan"
    ```

    > **_NOTE:_** The ```terraform apply``` command can take several minutes to complete

1. Fetch the loadbalancer IP address using ```terraform output loadbalancer_ip```

1. Update your DNS with the loadbalancer IP address

1. Fetch the Harbor URL using ```terraform output harbor_url_admin_login```

1. Make sure Harbor can be accessed using your browser, then proceed with stage 2

    > **_NOTE:_** It takes some time for the certificates to be signed and trusted, hence TLS server verification is currently disabled for Terraform providers used in stage 2. If you chose to enable the verification, you might hit the following error: ```tls: failed to verify certificate: x509: certificate signed by unknown authority```

1. Initialize, plan and apply stage 2
    ```
    cd ../stage_02
    terraform login
    terraform workspace show
    terraform init
    terraform plan -out="stage_02.plan"
    terraform apply "stage_02.plan"
    ```

1. Make sure the ```output.yaml``` file appeared. At this stage, the build cluster is complete. You can proceed with stage 3 to add remote clusters.

1. Initialize, plan and apply stage 3
    ```
    cd ../stage_03
    terraform login
    terraform workspace show
    terraform init
    terraform plan -out="stage_03.plan"
    terraform apply "stage_03.plan"
    ``` 

1. Find all the URLs, usernames and passwords needed in the ```output.yaml``` file

    > **_NOTE:_** The applications' sync status might be in an unkown state for a few minutes because ArgoCD fails to connect to the Harbor Helm registry. This is caused by the fact that Harbor initially serves an invalid certificate, and it takes some time for the correct certificate to be provisioned. Also, you might be hitting Let's Encrypt rate limit if you've reinstalled the services too many times lately.

    > **_NOTE:_** As ArgoCD takes over the responsibility for the components that were already deployed (e.g. Keycloak, Harbor), their related services will experience a short unavailability period.

## Uninstall

1. Destroy the infrastructure

    ```
    cd stage_02
    terraform destroy
    cd ../stage_01
    terraform destroy
    cd ..
    ```

1. Make sure the uninstallation was successful
    ```
    kubectl get ns
    # Expected output: system-level namespace only (e.g. kube-***)
    ```

    ```
    helm list -A
    # Expected output: system-level charts only (e.g. kube-***)
    ```

> **_NOTE:_** If something goes wrong during the uninstallation, you can run
```./scripts/nuke.sh``` to destroy everything without relying on Terraform

## License and Usage Restrictions

Any use of the software for purposes other than academic research, including for commercial purposes, shall be requested in advance from [CHUV](mailto:pactt.legal@chuv.ch).

## Acknowledgments

This project has received funding from the Swiss State Secretariat for Education, Research and Innovation (SERI) under contract number 23.00638, as part of the Horizon Europe project “EBRAINS 2.0”.
