#!/bin/bash

# Set JVM memory (adjust as needed)
export JAVA_OPTS="-Xmx200g"

# Paths
CONFIG_FILE="/path/to/your/config.yaml"

phgv2_path=$(yq '.phgv2_path' "$CONFIG_FILE")
hvcf_dir=$(yq '.hvcf_dir' "$CONFIG_FILE")
index_file=$(yq '.index_file' "$CONFIG_FILE")
key_file=$(yq '.key_file' "$CONFIG_FILE")
output_dir=$(yq '.output_dir' "$CONFIG_FILE")
min_mem_length=$(yq '.min_mem_length' "$CONFIG_FILE")
threads_readmapping=$(yq '.threads_readmapping' "$CONFIG_FILE")

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Run PHG read mapping
$phgv2_path map-reads \
    --hvcf-dir $hvcf_dir \
    --index $index_file \
    --key-file $key_file \
    --output-dir $outputdir_read_mapping= \
    --min-mem-length  \
    --threads 

# Echo parameters used
echo "[--hvcf-dir] = $HVCF_DIR"
echo "[--index] = $INDEX_FILE"
echo "[--key-file] = $KEY_FILE"
echo "[--output-dir] = $OUTPUT_DIR"







