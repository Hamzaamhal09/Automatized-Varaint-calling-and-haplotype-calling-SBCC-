import yaml

# Load PHG config file
with open("/home/hamzaamhal/snakemake_pipline2/config/config_paths_PHG.yaml") as f:
    config = yaml.safe_load(f)

# Set the active config file for Snakemake
configfile: "/home/hamzaamhal/snakemake_pipline2/config/config_paths_PHG.yaml"


# Final targets
rule all:
    input:
        config["PHG_INDEX_DONE"],
        config["PHG_MAPPING_DONE"]
        config["PHG_FIND_PATHS_LOG"]
rule index_pangenome:
    input:
        script = config["PHG_INDEX_SCRIPT"]
    output:
        config["PHG_INDEX_DONE"]
    params:
        log = config["PHG_INDEX_LOG"]
    shell:
        """
        nohup bash {input.script} > {params.log} 2>&1
        touch {output}
        """
rule phg_mapping:
    input:
        script = config["PHG_MAPPING_SCRIPT"]
    output:
        done = config["PHG_MAPPING_DONE"]
    params:
        log = config["PHG_MAPPING_LOG"]
    shell:
        """
        nohup bash {input.script} > {params.log} 2>&1
        touch {output.done}
        """
rule find_paths:
    input:
        script = config["PHG_FIND_PATHS_SCRIPT"]
    output:
        config["PHG_FIND_PATHS_DONE"]
    params:
        log = config["PHG_FIND_PATHS_LOG"]
    shell:
        """
        nohup bash {input.script} > {params.log} 2>&1
        touch {output}
        """
