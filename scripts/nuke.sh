#!/bin/bash

nuke() {
    # ARGOCD
    helm uninstall $cluster_name-argo-cd $cluster_name-argo-cd-cache -n argocd
    kubectl patch appprojects.argoproj.io $cluster_name --type=merge -p '{"metadata":{"finalizers":null}}' -n argocd
    kubectl delete appprojects.argoproj.io $cluster_name -n argocd
    kubectl delete ns argocd
    kubectl delete $(kubectl get crds -oname | grep argoproj.io)

    # ARGO-EVENTS
    kubectl delete $(kubectl get deployment -oname -n argo-events) -n argo-events
    kubectl delete ns argo-events

    # PROMETHEUS
    kubectl delete $(kubectl get deployment -oname -n prometheus) -n prometheus
    challenges=$(kubectl get challenges.acme.cert-manager.io -oname -n prometheus)
    for challenge in $challenges; do
        kubectl patch $challenge --type=merge -p '{"metadata":{"finalizers":null}}' -n prometheus
        kubectl delete $challenge -n prometheus
    done
    kubectl delete ns prometheus
    kubectl delete $(kubectl get crds -oname | grep coreos.com)
    kubectl delete $(kubectl get crds -oname | grep aquasecurity.github.io)

    # ARGO-WORKFLOW
    kubectl patch $(kubectl get challenges.acme.cert-manager.io -oname -n kube-system) --type=merge -p '{"metadata":{"finalizers":null}}' -n kube-system
    kubectl delete $(kubectl get challenges.acme.cert-manager.io -oname -n kube-system) -n kube-system
    kubectl delete $(kubectl get deployments.apps -oname -n kube-system | grep "argo-workflows") -n kube-system
    kubectl delete secret argo-workflows-oidc argo-workflows-tls -n kube-system
    kubectl delete ns argo

    # TRIVY
    kubectl delete deployment $cluster_name-trivy-operator -n trivy-system
    kubectl delete ns trivy-system

    # HARBOR
    helm uninstall $cluster_name-harbor $cluster_name-harbor-cache $cluster_name-harbor-db -n harbor
    kubectl delete ns harbor

    # KEYCLOAK
    helm uninstall $cluster_name-keycloak $cluster_name-keycloak-db -n keycloak
    kubectl delete ns keycloak

    # CERT-MANAGER
    helm uninstall $cluster_name-cert-manager $cluster_name-self-signed-issuer -n cert-manager
    kubectl delete ns cert-manager
    kubectl delete $(kubectl get crds -oname | grep cert-manager.io)

    # NGINX
    helm uninstall $cluster_name-ingress-nginx -n ingress-nginx
    kubectl delete ns ingress-nginx
}

# --- Script Execution Start ---

current_context=$(kubectl config current-context)
cat << EOF
########################################################################
#  _____                                     ______                    #
# |  __ \                                   |___  /                    #
# | |  | |  __ _  _ __    __ _   ___  _ __     / /  ___   _ __    ___  #
# | |  | | / _  ||  _ \  / _  | / _ \|  __|   / /  / _ \ |  _ \  / _ \\ #
# | |__| || (_| || | | || (_| ||  __/| |     / /__| (_) || | | ||  __/ #
# |_____/  \__,_||_| |_| \__, | \___||_|    /_____|\___/ |_| |_| \___| #
#                         __/ |                                        #
#                        |___/                                         #
########################################################################
EOF

echo -e "\nYou are about to destroy the resources found in the $(tput bold) $current_context $(tput sgr0) context\n"
read -p "Please type the context name to confirm: " user_input_context
if [[ "$user_input_context" == "$current_context" ]]; then
    cluster_name=$current_context
    read -p "Please type the cluster name used for the installation (default: $current_context): " cluster_name
    nuke
else
    echo "Canceling"
    exit 0
fi