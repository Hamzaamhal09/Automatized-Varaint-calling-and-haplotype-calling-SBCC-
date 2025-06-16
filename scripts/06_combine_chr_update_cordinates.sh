#!/bin/bash

### Script: Merge part-chromosome coordinates into full chromosomes in VCF
### Author: C.P. Cantalapiedra (modified with path variables)

#======================#
# Define Input/Output  #
#======================#

# ==== PATH VARIABLES ====
# Assume config file path is in $config_file
config_file="/home/hamzaamhal/snakemake_pipline/config/config_paths.yaml"

BED_FILE=$(yq eval '.BED_FILE' "$config_file")
FINAL_OUTPUT=$(yq eval '.FINAL_OUTPUT' "$config_file")
VCF_WITH_MERGED_COORDS=$(yq eval '.VCF_WITH_MERGED_COORDS' "$config_file")
VCF_WITH_MERGED_COORDS_GZ=$(yq eval '.VCF_WITH_MERGED_COORDS_GZ' "$config_file")
VCF_FINAL=$(yq eval '.VCF_FINAL' "$config_file")


#======================#
# Coordinate Remapping #
#======================#

awk 'FNR==NR{
    if ($5 != 0) { v[$4] = $5; }
    next
}
{
    if (substr($0, 1, 1) == "#") { print $0; next; }
    if ($1 == "chrUn") { print $0; next; }
    chrom = substr($1, 1, 5);
    part = substr($1, 7);
    pos = ($1 == "chrUn" || part == "0") ? $2 : ($2 + v[chrom]);
    printf chrom "\t" pos "\t";
    for (i = 3; i <= NF; i++) {
        printf $i;
        if (i < NF) printf "\t"; else printf "\n";
    }
}' "$BED_FILE" "$FINAL_OUTPUT" > "$VCF_WITH_MERGED_COORDS"

#======================#
# Compress & Index     #
#======================#

bgzip -c "$VCF_WITH_MERGED_COORDS" > "$VCF_WITH_MERGED_COORDS_GZ"
bcftools index -c "$VCF_WITH_MERGED_COORDS_GZ"

#======================#
# Add MISSING/MAF Tags #
#======================#

bcftools +fill-tags "$VCF_WITH_MERGED_COORDS_GZ" -- -t F_MISSING,MAF | \
    bcftools view -Oz -o "$VCF_FINAL"
