#!/bin/sh

set -e

# This scripts assume that the following
# environment varibales exist
# KUBECONFIG
# OBJECT_TYPE
# OBJECT_ID
# ATTACH_TO
# NAMESPACE (optional)

export KUBECONFIG

if [ -n "$NAMESPACE" ]; then
  NS_FLAG="--namespace=$NAMESPACE"
else
  NS_FLAG=""
fi

if kubectl get "$OBJECT_TYPE" "$OBJECT_ID" "$NS_FLAG" >/dev/null 2>&1; then
  echo "$OBJECT_TYPE $OBJECT_ID exists, importing into Terraform..."
  terraform import "$ATTACH_TO" "$OBJECT_ID"
else
  echo "$OBJECT_TYPE $OBJECT_ID does not exist, will be created by Terraform."
fi