#!/bin/bash

# Author: CPCantalapiedra 2017
# Modified by: Ruben Sancho, 2024, EEAD-CSIC
# Further modified by: Hamza

# Directories and parameters
GATK="/home/contrera/soft/gatk-4.3.0.0/gatk-package-4.3.0.0-local.jar"
reference_genome="/data/hamza/reference/barley_v3_split_2_parts.fa"
output_dir_markdup="/data/hamza/markduplicate/bam_dup/"
output_dir="/data/hamza/gvcf_files_Nodup2"
threads_variantcall=7

mkdir -p  $output_dir

# File with the list of sample names
variant_list="/home/hamzaamhal/variant_calling/Variant_calling_list.txt"

# Process each sample
cat "$variant_list" | while read sample; do
    echo "Processing sample: $sample"

    # Output file path
    output_file="$output_dir/${sample}.g.vcf"

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
