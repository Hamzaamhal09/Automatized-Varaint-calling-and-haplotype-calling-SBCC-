#!/bin/bash

# Author: CPCantalapiedra 2017
# Modified by: Ruben Sancho, 2024, EEAD-CSIC
# Further modified by: Hamza

# Directories and parameters


# Path to the config file
config_file="/home/hamzaamhal/snakemake_pipline2/config/config_paths.yaml"

# Read values from YAML config file
GATK=$(yq eval '.GATK' $config_file)
reference_genome=$(yq eval '.reference_genome' $config_file)
output_dir_markdup=$(yq eval '.output_dir_markdup' $config_file)
output_dir_singl_gvcf=$(yq eval '.output_dir_singl_gvcf' $config_file)
threads_variantcall=$(yq eval '.threads_variantcall' $config_file)
variant_calling_list=$(yq eval '.variant_calling_list' $config_file)

# Check if any variable is empty
if [ -z "$GATK" ] || [ -z "$reference_genome" ] || [ -z "$output_dir_markdup" ] || \
   [ -z "$output_dir_singl_gvcf" ] || [ -z "$threads_variantcall" ] || [ -z "$variant_calling_list" ]; then
    echo "Error: Missing required arguments in config file."
    exit 1
fi



mkdir -p  $output_dir_singl_gvcf


# Process each sample
cat "$variant_calling_list" | while read sample; do
    echo "Processing sample: $sample"

    # Output file path
    output_file="$output_dir_singl_gvcf/${sample}.g.vcf"

    # Check if output file already exists
    if [ -f "$output_file" ]; then
        echo "Output file for $sample already exists. Skipping."
    else
        echo "Running GATK HaplotypeCaller for $sample"

        java -jar "$GATK" HaplotypeCaller \
            -R "$reference_genome" \
            -I "${output_dir_markdup}/${sample}.sort.markdup.bam" \
            -O "$output_file" \
            -ERC GVCF \
            -G StandardAnnotation -G AS_StandardAnnotation \
            --native-pair-hmm-threads "$threads_variantcall" \
            --read-filter NotSecondaryAlignmentReadFilter
    fi
done
