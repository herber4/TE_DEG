
### fetch the repeatmasker annotation file for gencode assembly

````
wget https://labshare.cshl.edu/shares/mhammelllab/www-data/TEtranscripts/TE_GTF/GRCh38_GENCODE_rmsk_TE.gtf.gz
````

### utilize featureCounts function in the subread package to quantify all - unique and multimapped - reads to the reduced GTF repeat annotation file

````
module load subread
````

````
featureCounts -T 16 -F GTF -a GRCh38_GENCODE_rmsk_TE.gtf -t exon -g gene_id --extraAttributes transcript_id,family_id,class_id -O -M --fraction --primary -s 0 -p -o te_counts.txt *.bam
````

### on the command line, use awk to slice out columns of interest as input to edgeR

awk -F'\t' 'BEGIN{OFS=FS}{$2=$3=$4=$5=$6=$7=""; gsub("[\t]+","\t")}1' te_counts.txt > output_reduced.txt


