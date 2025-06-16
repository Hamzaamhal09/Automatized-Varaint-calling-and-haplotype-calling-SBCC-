#!/bin/bash

# Set input and output directories
#!/bin/bash

# Load config from YAML using yq
CONFIG_FILE="/home/hamzaamhal/snakemake_pipline2/config/config_paths.yaml"  # Update this to your actual path

fastq_input=$(yq '.fastq_input' "$CONFIG_FILE")
quality_check_output=$(yq '.quality_check_output' "$CONFIG_FILE")

# Create output directory if it doesn't exist
mkdir -p "$quality_check_output"

# Run FastQC on all .fastq.gz files
for file in "$fastq_input"/*.fastq.gz; do
    echo "Running FastQC on $file..."
    fastqc -o "$quality_check_output" "$file"
done

# Run MultiQC to summarize FastQC results
echo "Running MultiQC..."
multiqc "$quality_check_output" -o "$quality_check_output"

echo "All done. FastQC and MultiQC reports are in $quality_check_output"
