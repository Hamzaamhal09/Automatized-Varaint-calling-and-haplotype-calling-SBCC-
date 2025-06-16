## CPCantalapiedra 2017
## Modified by Ruben Sancho, 2024, EEAD-CSIC


GATK="/home/hamzaamhal/gatk-4.6.1.0/gatk-package-4.6.1.0-local.jar";
refSeq="/data/hamza/reference/barley_v3_split_2_parts.fa";
output_dir="/data/hamza/gvcf_files/combined_gvcf_file"
TEMP="/data/hamza/gvcf_files/temporal"

# First, use GenomicsDBImports (option 1) or CombineGVFs (option 2) 
# See: https://gatk.broadinstitute.org/hc/en-us/articles/360035889971--How-to-Consolidate-GVCFs-for-joint-calling-with-GenotypeGVCFs



## OPTION 1

# make temp_GATK
java -Xmx150g -jar -Xmx250g -DGATK_STACKTRACE_ON_USER_EXCEPTION=true "$GATK" GenomicsDBImport --genomicsdb-workspace-path "$output_dir" --intervals interval2.list --batch-size 25 --consolidate true --interval-merging-rule ALL --reference "$refSeq" --tmp-dir "$TEMP" --reader-threads 5 --sample-name-map cohort.sample_map.list # specifies sample names and the path of the input files


#java -Xmx150g -jar "$GATK" GenomicsDBImport \
	#--genomicsdb-workspace-path "$output_dir" \ # the output file directory
	#--intervals interval.list \ # you should sepcify the region of the genome that you are intersted in , if you are intersted in the whole genome you should put the chromosome sizes
	#--batch-size 25 \ # specifies the number of files to open at the  same time
	#--consolidate true \ #  USED TO reduce memory consumption  when using batches , it is recommded to use when you have hundreds of samples
	#--interval-merging-rule ALL \ # merges the intervals mentioned in the interval list
	#--reference "$refSeq" \ # path to the reference genome
	#--tmp-dir "$TEMP" \ # path to intermediate directory where the  temporary files will be stored
	#--reader-threads 5 \ # speifies the number of threads
	#--sample-name-map cohort.sample_map.list; # specifies
# OPTION 2




# Second, perform joint genotyping on one or more samples pre-called with HaplotypeCaller

#java -Xmx200g -jar "$GATK" GenotypeGVCFs \
	#-R "$refSeq" \
	#-O /data/hamza/gvcf_files/SBCC.vcf \
	#-V gendb://"$output_dir"

for CHR in chr1H_0 chr1H_1 chr2H_0 chr2H_1 chr3H_0 chr3H_1 chr4H_0 chr4H_1 chr5H_0 chr5H_1 chr6H_0 chr6H_1 chr7H_0 chr7H_1 chrUn; do
    OUTPUT_FILE="/data/hamza/gvcf_files/SBCCjustatry_${CHR}.vcf"
    if [ ! -f "$OUTPUT_FILE" ]; then
        java -Xmx200g -jar "$GATK" GenotypeGVCFs \
            -R "$refSeq" \
            -O "$OUTPUT_FILE" \
            -V "gendb://$output_dir" \
            -L "$CHR"
    else
        echo "File $OUTPUT_FILE already exists, skipping $CHR."
    fi
done

# joint all sepertaed files for each chromosomes into one file
java -Xmx200g -jar "$GATK" GatherVcfs \
    -R "$refSeq" \
    -O /data/hamza/gvcf_files/SBCC_combined.vcf \
    $(for CHR in chr1H_0 chr1H_1 chr2H_0 chr2H_1 chr3H_0 chr3H_1 chr4H_0 chr4H_1 chr5H_0 chr5H_1 chr6H_0 chr6H_1 chr7H_0 chr7H_1 chrUn; do echo -n "-I /data/hamza/gvcf_files/SBCC_${CHR}.vcf "; done)


## END
