import yaml

# Load general config
with open("/home/hamzaamhal/snakemake_pipline/config/config.yaml") as f:
    config_general = yaml.safe_load(f)

# Load path config
with open("/home/hamzaamhal/snakemake_pipline/config/config_paths.yaml") as f:
    config_paths = yaml.safe_load(f)

# Set the active config file
configfile: "/home/hamzaamhal/snakemake_pipline/config/config_paths.yaml"

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

# Final targets
rule all:
    input:
        expand("/home/hamzaamhal/calida_reads/results/quality_report/{name}_{unit}_fastqc.html", name=samples_name, unit=samples_unit),
        expand("/home/hamzaamhal/calida_reads/results/quality_report/{name}_{unit}_fastqc.zip", name=samples_name, unit=samples_unit),
        mapping_done,
        mark_duplicates_done

rule quality_check:
    input:
        fq1 = expand("/home/hamzaamhal/calida_reads/data/{name}_{unit}_R1.fastq.gz", name=samples_name, unit=samples_unit),
        fq2 = expand("/home/hamzaamhal/calida_reads/data/{name}_{unit}_R2.fastq.gz", name=samples_name, unit=samples_unit)
    output:
        html = expand("/home/hamzaamhal/calida_reads/results/quality_report/{name}_{unit}_fastqc.html", name=samples_name, unit=samples_unit),
        zip = expand("/home/hamzaamhal/calida_reads/results/quality_report/{name}_{unit}_fastqc.zip", name=samples_name, unit=samples_unit)
    shell:
        """
        fastqc -o /home/hamzaamhal/calida_reads/results/quality_report {input.fq1} {input.fq2}
        """

rule map_reads:
    input:
        script = mapping_script
    output:
        mapping_done
    shell:
        """
        bash {input.script} > {mapping_output_log} 2>&1
        touch {output}
        """
rule mark_duplicates:
    input:
        script = mark_duplicates_script
    output:
        mark_duplicates_done
    shell:
        """
        bash {input.script} > {mark_duplicates_output_log} 2>&1
        touch {output}
        """
