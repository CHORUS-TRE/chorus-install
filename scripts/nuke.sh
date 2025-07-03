#!/bin/bash

cluster_name=chorus-build-t

# ARGOCD
kubie ns argocd
helm uninstall $cluster_name-argo-cd $cluster_name-argo-cd-cache
kubectl patch appprojects.argoproj.io $cluster_name --type=merge -p '{"metadata":{"finalizers":null}}'
kubectl delete appprojects.argoproj.io $cluster_name
kubectl delete ns argocd
kubectl delete $(kubectl get crds -oname | grep argoproj.io)

# ARGO-EVENTS
kubie ns argo-events
kubectl delete $(kubectl get deployment -oname)
kubectl delete ns argo-events

# PROMETHEUS
kubie ns prometheus
kubectl delete $(kubectl get deployment -oname)
challenges=$(kubectl get challenges.acme.cert-manager.io -oname)
for challenge in $challenges; do
    kubectl patch $challenge --type=merge -p '{"metadata":{"finalizers":null}}'
    kubectl delete $challenge
done
kubectl delete ns prometheus
kubectl delete $(kubectl get crds -oname | grep coreos.com)
kubectl delete $(kubectl get crds -oname | grep aquasecurity.github.io)

# ARGO-WORKFLOW
kubie ns kube-system
kubectl patch $(kubectl get challenges.acme.cert-manager.io -oname) --type=merge -p '{"metadata":{"finalizers":null}}'
kubectl delete $(kubectl get challenges.acme.cert-manager.io -oname)
kubectl delete secret argo-workflows-oidc argo-workflows-tls
kubectl delete ns argo

# TRIVY
kubie ns trivy-system
kubectl delete deployment $cluster_name-trivy-operator
kubectl delete ns trivy-system

# HARBOR
kubie ns harbor
helm uninstall $cluster_name-harbor $cluster_name-harbor-cache $cluster_name-harbor-db
kubectl delete ns harbor

# KEYCLOAK
kubie ns keycloak
helm uninstall $cluster_name-keycloak $cluster_name-keycloak-db
kubectl delete ns keycloak

# CERT-MANAGER
kubie ns cert-manager
helm uninstall $cluster_name-cert-manager $cluster_name-self-signed-issuer
kubectl delete ns cert-manager
kubectl delete $(kubectl get crds -oname | grep cert-manager.io)

# NGINX
kubie ns ingress-nginx
helm uninstall $cluster_name-ingress-nginx
kubectl delete ns ingress-nginx