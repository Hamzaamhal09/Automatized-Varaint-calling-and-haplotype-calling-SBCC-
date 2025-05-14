#!/bin/bash

# Default values
REF=""
INFO=""
BAM_DIR=""
FLAGSTAT_DIR=""
INDEX_DIR=""
IDXSTATS_DIR=""
BWA_PATH=""
THREADS=1

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --ref) REF="$2"; shift ;;
        --info) INFO="$2"; shift ;;
        --bam-dir) BAM_DIR="$2"; shift ;;
        --flagstat-dir) FLAGSTAT_DIR="$2"; shift ;;
        --index-dir) INDEX_DIR="$2"; shift ;;
        --idxstats-dir) IDXSTATS_DIR="$2"; shift ;;
        --bwa-path) BWA_PATH="$2"; shift ;;
        --threads) THREADS="$2"; shift ;;
        *) echo "Unknown option $1"; exit 1 ;;
    esac
    shift
done

# Print variables
echo "Reference: $REF"
echo "Info file: $INFO"
echo "Threads: $THREADS"

# Index the reference genome
$bwa_path index $REF

# Mapping loop
cat $INFO | while read -r ids ori_name pu pl sm reads1 reads2
do
    # BWA-MEM2 mapping and sorting to BAM
    $BWA_PATH mem \
        -t $THREADS \
        -R "@RG\tID:$ids\tSM:$sm\tPL:$pl\tLB:$sm" "$REF" \
        <(zcat "$reads1") \
        <(zcat "$reads2") | \
    samtools view -bS | \
    samtools sort -@ $THREADS -o "$BAM_DIR/$sm.sort.bam" && \
    
    # Generate flagstat
    samtools flagstat "$BAM_DIR/$sm.sort.bam" > "$FLAGSTAT_DIR/$sm.flagstat.txt" && \
    
    # Index BAM file
    samtools index "$BAM_DIR/$sm.sort.bam" \
        "$INDEX_DIR/$sm.sort.bam.bai" && \
    
    # Generate idxstats
    samtools idxstats "$BAM_DIR/$sm.sort.bam" > "$IDXSTATS_DIR/$sm.idxstats.txt"
done
