#!/bin/bash
set -e

if [[ "$1" == "--debug" ]]; then
  set -x
  shift
fi

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo "This script extracts the version from a collection of charts\
        in order to generate a release file to be used as input for\
        the CHORUS-TRE automated installation"
    echo "Use the '--debug' option to see the full trace"
    exit 0
fi


charts_folder=$1
output_file=$2
charts=$(find $charts_folder -mindepth 2 -maxdepth 2 -type d -not -path "$charts_folder/.*" | sort)
declare -a charts_versions=()
for chart in $charts; do
    app_version=$(yq '.appVersion' $chart/Chart.yaml)
    version=$(yq '.version' $chart/Chart.yaml)
    if [ "${app_version}" == "null" ]; then
      charts_versions+=("$(basename $chart):\n    version: $version")
    else
      charts_versions+=("$(basename $chart):\n    version: $version\n    appVersion: $app_version")
    fi
done

touch $output_file
echo "---" > $output_file
echo "charts:" >> $output_file
for item in "${charts_versions[@]}"; do
  echo -e "  $item" >> $output_file
done
