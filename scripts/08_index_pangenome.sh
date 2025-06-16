#!/bin/bash

# Load config from YAML using yq
CONFIG_FILE="/home/hamzaamhal/snakemake_pipline2/config/config_paths_PHG.yaml"

hvcf_dir=$(yq '.hvcf_dir' "$CONFIG_FILE")
db_path=$(yq '.db_path' "$CONFIG_FILE")
index_output_dir=$(yq '.index_output_dir' "$CONFIG_FILE")
index_prefix=$(yq '.index_prefix' "$CONFIG_FILE")
phgv2_path=$(yq '.phgv2_path' "$CONFIG_FILE")

# Create output directory if it doesn't exist
mkdir -p "$index_output_dir"

# Set max JVM heap memory
export JAVA_OPTS="-Xmx100g"

# Run rope-bwt-index
"$phgv2_path" rope-bwt-index \
    --db-path "$db_path" \
    --hvcf-dir "$hvcf_dir" \
    --output-dir "$index_output_dir" \
    --threads 40 \
    --index-file-prefix "$index_prefix"

# Echo parameters
echo "[--db-path] = $db_path"
echo "[--hvcf-dir] = $hvcf_dir"
echo "[--output-dir] = $index_output_dir"
echo "[--index-file-prefix] = $index_prefix"
