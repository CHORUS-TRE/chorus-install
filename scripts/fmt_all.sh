#!/bin/bash

set -e

# Format all modules
for dir in modules/*/; do
  if ls "$dir"*.tf 1> /dev/null 2>&1; then
    terraform fmt "$dir"
  fi
done

# Format all stage_* directories
for dir in stage_*/; do
  if ls "$dir"*.tf 1> /dev/null 2>&1; then
    terraform fmt "$dir"
  fi
done