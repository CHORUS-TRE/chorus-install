#!/bin/sh

set -e

import_object="$1"
import_id="$2"
import_to="$3"

if kubectl get "$import_object" "$import_id"  >/dev/null 2>&1; then
  echo "$import_object $import_id exists, importing into Terraform..."
  terraform import "$import_to" "$import_id"
else
  echo "$import_object $import_id does not exist, will be created by Terraform."
fi