# Pipeline Overview

This is a preliminary release of the pipeline. You can:

    Run the entire pipeline via the provided .smk (Snakemake) files,

    Execute individual steps from the .smk files, or

    Run each component directly from the corresponding scripts in the scripts/ directory.

 The pipeline is divided into two main parts:
1. Variant Calling

Defined in the snakemakepipline.smk script. This section performs the full variant discovery workflow using GATK haplotype caller :

    check_quality
    Runs a script to assess read quality and produces a completion flag file.

    map_reads
    Maps reads to the reference genome using a bash script and creates a completion marker.

    mark_duplicates
    Identifies and marks duplicate reads in the BAM files.

    variant_calling
    Calls variants for each sample using GATK's HaplotypeCaller.

    genotype_all
    Performs joint genotyping across all variant call files.

    combine_chr_update_coordinates
    Merges per-chromosome VCFs and updates coordinates accordingly.

    filter_vcf
    Applies quality-based filtering to the final VCF files.

    Imputation and Phasing (upcoming)


2. Haplotype Determination using the Practical Haplotype Graph (PHG)

Defined in the PHG_snakmake.smk script. This section uses PHG to identify haplotypes:

    index_pangenome
    Indexes the reference pangenome for PHG usage.

    phg_mapping
    Maps reads to the PHG graph representation.

    find_paths
    Infers the most probable haplotype paths per sample.
    
    Merged hvcf files
    Merge the single hvcf files into one hvcf file

    # instalation guide 

    first you will have to install conda and snakemke 

    <pre> ```bash conda create -c conda-forge -c bioconda -n snakemake snakemake ``` </pre>



