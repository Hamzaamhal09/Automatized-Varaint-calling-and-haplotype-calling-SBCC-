import yaml

# Load general config
with open("/home/hamzaamhal/snakemake_pipline2/config/config.yaml") as f:
    config_general = yaml.safe_load(f)

# Load path config
with open("/home/hamzaamhal/snakemake_pipline2/config/config_paths.yaml") as f:
    config_paths = yaml.safe_load(f)

# Set the active config file
configfile: "/home/hamzaamhal/snakemake_pipline2/config/config_paths.yaml"

# Input values
samples_name = config_general["samples_name"]
samples_unit = config_general["samples_unit"]

# Path values from config_paths for mapping
mapping_output_log = config_paths["mapping_output_log"]
mapping_script = config_paths["mapping_script"]
mapping_done = config_paths["mapping_done"]
# path values for marking duplicates 

mark_duplicates_script = config_paths["mark_duplicates_script"]
mark_duplicates_done = config_paths["mark_duplicates_done"]
mark_duplicates_output_log = config_paths["mark_duplicates_output_log"]
# path values for single vcf variant calling using haplotype caller

variant_calling_script = config_paths["variant_calling_script"]
variant_calling_done = config_paths["variant_calling_done"]
variant_calling_output_log = config_paths["variant_calling_log"]


# Genotyping paths from config
genotype_all_script = config_paths["genotype_all_script"]
genotype_all_output_log = config_paths["genotype_all_output_log"]
genotype_all_output = config_paths["genotype_all_output"]

# Final targets
rule all:
    input:
        config["CHECK_QUALITY_DONE"],
        mapping_done,
        mark_duplicates_done,
        variant_calling_done,
        genotype_all_output,
        config["COMBINE_CHR_DONE"],
        config["FILTER_VCF_DONE"]

rule check_quality:
    input:
        script = config["CHECK_QUALITY_SCRIPT"]
    output:
        config["CHECK_QUALITY_DONE"]
    params:
        log = config["CHECK_QUALITY_LOG"]
    shell:
        """
        nohup bash {input.script} > {params.log} 2>&1
        touch {output}
        """
rule map_reads:
    input:
        script = mapping_script
    output:
        mapping_done
    shell:
        """
        nohup bash {input.script} > {mapping_output_log} 2>&1
        touch {output}
        """
rule mark_duplicates:
    input:
        script = mark_duplicates_script
    output:
        mark_duplicates_done
    shell:
        """
        nohup bash {input.script} > {mark_duplicates_output_log} 2>&1
        touch {output}
        """
rule variant_calling:
    input:
        script = variant_calling_script
    output:
        variant_calling_done
    params:
        log = variant_calling_output_log
    shell:
        """
        nohup bash {input.script} > {params.log} 2>&1
        touch {output}
        """
rule genotype_all:
    input:
        script = genotype_all_script
    output:
        genotype_all_output
    params:
        log = genotype_all_output_log
    shell:
        """
        nohup bash {input.script} > {params.log} 2>&1
        touch {output}
        """
rule combine_chr_update_coordinates:
    input:
        script = config["COMBINE_CHR_SCRIPT"]
    output:
        config["COMBINE_CHR_DONE"]
    params:
        log = config["COMBINE_CHR_LOG"]
    shell:
        """
        bash {input.script} > {params.log} 2>&1
        touch {output}
        """
rule filter_vcf:
    input:
        script = config["FILTER_VCF_SCRIPT"]
    output:
        config["FILTER_VCF_DONE"]
    params:
        log = config["FILTER_VCF_LOG"]
    shell:
        """
        bash {input.script} > {params.log} 2>&1
        touch {output}
        """
