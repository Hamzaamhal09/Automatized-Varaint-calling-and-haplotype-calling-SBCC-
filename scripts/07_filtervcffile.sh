#!/bin/bash

# Path to the input VCF file
#!/bin/bash

config_file="/home/hamzaamhal/snakemake_pipline/config/config_paths.yaml"

VCF_FINAL=$(yq eval '.VCF_FINAL' "$config_file")
FILTERED_VCF=$(yq eval '.FILTERED_VCF' "$config_file")

bcftools view -i 'INFO/DP>=5 & INFO/MAF>=0.05 & INFO/F_MISSING<=0.2' "$VCF_FINAL" | bgzip -c > "$FILTERED_VCF"
bcftools index "$FILTERED_VCF"

echo "Filtering complete. Output saved to $FILTERED_VCF"


# Filter the VCF file for variants with a depth (DP) of 5 or more,
# MAF greater than or equal to 0.05, and missingness less than or equal to 0.2
bcftools view -i 'INFO/DP>=5 & INFO/MAF>=0.05 & INFO/F_MISSING<=0.2' $INPUT_VCF | bgzip -c > $OUTPUT_VCF
bcftools index $OUTPUT_VCF

echo "Filtering complete. Output saved to $OUTPUT_VCF"
