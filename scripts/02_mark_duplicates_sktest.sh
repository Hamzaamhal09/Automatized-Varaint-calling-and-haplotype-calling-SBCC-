#!/bin/bash

#!/bin/bash
## This script marks duplicated reads in BAM alignments before using GATK tools
#!/bin/bash
## This script marks duplicated reads in BAM alignments before using GATK tools

# Path to the config file
config_file="/home/hamzaamhal/snakemake_pipline/config/config_paths.yaml"

# Read values from YAML config file
output_dir_markdup=$(yq eval '.output_dir_m' $config_file)
metrics_dir=$(yq eval '.metrics_dir' $config_file)
bam_dir=$(yq eval '.bam_dir' $config_file)
variant_calling_list=$(yq eval '.variant_calling_list' $config_file)

# Check if any variable is empty (which means the value wasn't found in the config file)
if [ -z "$output_dir_markdup" ] || [ -z "$metrics_dir" ] || [ -z "$bam_dir" ] || [ -z "$variant_calling_list" ]; then
    echo "Error: Missing required arguments in config file."
    exit 1
fi


# Create output directories if they do not exist
mkdir -p "$output_dir_markdup"
mkdir -p "$metrics_dir"



# Loop through each sample listed in Variant_calling_list.txt
while IFS= read -r sample; do
    echo "Processing sample: $sample"
    name=$(basename "$sample")
    echo "Sample name: $name"

    # Full path to the input BAM file
    input_bam="$bam_dir/$sample.sort.bam"

    # Check if the input BAM file exists
    if [ ! -f "$input_bam" ]; then
        echo "ERROR: BAM file $input_bam not found. Skipping this sample."
        continue  # Skip to the next sample if the BAM file is not found
    fi

    # Run Picard MarkDuplicates
    java -jar /home/rsancho/software/picard.jar MarkDuplicates \
          --INPUT "$input_bam" \
          --OUTPUT "$output_dir_markdup/$name.sort.markdup.bam" \
          --METRICS_FILE "$metrics_dir/$name.metrics.txt" \
          --OPTICAL_DUPLICATE_PIXEL_DISTANCE 2500 \
          --CREATE_INDEX false \
          --REMOVE_DUPLICATES false \
          --REMOVE_SEQUENCING_DUPLICATES false \
          --ASSUME_SORTED true \
          --CLEAR_DT false

    if [ $? -eq 0 ]; then
        # Index the output BAM file
        samtools index "$output_dir_markdup/$name.sort.markdup.bam"
    else
        echo "ERROR: Picard MarkDuplicates failed for $sample. Skipping BAM indexing."
    fi

done < "$variant_calling_list"  # This is where we read the file line by line
