#!/bin/bash

set -e

helm_values_folder=$1
output_file=$2


declare -a charts_versions=()

for chart_dir in "$helm_values_folder"/*/; do
if [ -d "$chart_dir" ] && [ -f "$chart_dir/config.json" ]; then
    chart_name=$(jq -r '.chart' "$chart_dir/config.json")
    chart_version=$(jq -r '.version' "$chart_dir/config.json")
    charts_versions+=("$chart_name:\n    version: $chart_version")
fi
done

touch "$output_file"
echo "---" > "$output_file"
echo "charts:" >> "$output_file"
for item in "${charts_versions[@]}"; do
echo -e "  $item" >> "$output_file"
done