#!/bin/bash

# Path to the config file
CONFIG_FILE="/home/hamzaamhal/snakemake_pipline2/config/config_paths_PHG.yaml"

# Extract variables using yq
phgv2_path=$(yq '.phgv2_path' "$CONFIG_FILE")
hvcf_dir=$(yq '.hvcf_dir' "$CONFIG_FILE")
path_keyfile=$(yq '.path_keyfile' "$CONFIG_FILE")
reference_genome=$(yq '.reference_genome' "$CONFIG_FILE")
outputdir_find_paths=$(yq '.outputdir_find_paths' "$CONFIG_FILE")


# Create output directory if it doesn't exist
mkdir -p "$outputdir_find_paths"

# Run PHG find-paths
"$phgv2_path" find-paths \
    --path-keyfile "$path_keyfile" \
    --hvcf-dir "$hvcf_dir" \
    --reference-genome "$reference_genome" \
    --path-type haploid \
    --output-dir "$outputdir_find_paths" \
    --threads 20

# Echo parameters used
echo "[--path-keyfile] = $path_keyfile"
echo "[--hvcf-dir] = $hvcf_dir"
echo "[--reference-genome] = $reference_genome"
echo "[--output-dir] = $outputdir_find_paths"
