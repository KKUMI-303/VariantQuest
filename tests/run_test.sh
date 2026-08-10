#!/usr/bin/env bash

set -e

echo "Running VariantQuest..."
echo

snakemake \
    --cores 2 \
    --configfile tests/config/config_ci.yaml

echo
echo "Pipeline complete."
echo
echo "Validating variants..."
echo

python tests/scripts/validate_vcf.py
