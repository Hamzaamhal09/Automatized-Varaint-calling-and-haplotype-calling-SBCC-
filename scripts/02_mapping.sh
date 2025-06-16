#!/bin/bash

# Load config from YAML using yq
CONFIG_FILE="/home/hamzaamhal/snakemake_pipline2/config/config_paths.yaml"  # Adjust if needed

reference_genome=$(yq '.reference_genome' "$CONFIG_FILE")
info_file=$(yq '.info_file' "$CONFIG_FILE")
bam_dir=$(yq '.bam_dir' "$CONFIG_FILE")
flagstat_dir=$(yq '.flagstat_dir' "$CONFIG_FILE")
index_dir=$(yq '.index_dir' "$CONFIG_FILE")
idxstats_dir=$(yq '.idxstats_dir' "$CONFIG_FILE")
threads=$(yq '.threads' "$CONFIG_FILE")

# Print variables
echo "Reference: $reference_genome"
echo "Info file: $info_file"
echo "Threads: $threads"

# Create output directories if they don't exist
mkdir -p "$bam_dir"
mkdir -p "$flagstat_dir"
mkdir -p "$index_dir"
mkdir -p "$idxstats_dir"

# Index the reference genome
bwa index "$reference_genome"

# Mapping loop
cat "$info_file" | while read -r ids ori_name pu pl sm reads1 reads2
do
    # BWA-MEM2 mapping and sorting to BAM
    bwa mem \
        -t "$threads" \
        -R "@RG\tID:$ids\tSM:$sm\tPL:$pl\tLB:$sm" "$reference_genome" \
        <(zcat "$reads1") \
        <(zcat "$reads2") | \
    samtools view -bS | \
    samtools sort -@ "$threads" -o "$bam_dir/$sm.sort.bam" && \

    # Generate flagstat
    samtools flagstat "$bam_dir/$sm.sort.bam" > "$flagstat_dir/$sm.flagstat.txt" && \

    # Index BAM file
    samtools index "$bam_dir/$sm.sort.bam" "$bam_dir/$sm.sort.bam.bai" && \

    # Generate idxstats
    samtools idxstats "$bam_dir/$sm.sort.bam" > "$idxstats_dir/$sm.idxstats.txt"
done
