config_file="/home/hamzaamhal/snakemake_pipline/config/config_paths.yaml"
mapfile -t CHROMOSOMES < <(yq eval '.CHROMOSOMES[]' "$config_file")
printf "%s\n" "${CHROMOSOMES[@]}"
