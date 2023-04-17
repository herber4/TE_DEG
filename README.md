# TE_DEG
This repo contains tutorial for quantifying expression of transposable elements from bulk RNA-seq experiments.

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

````
awk -F'\t' 'BEGIN{OFS=FS}{$2=$3=$4=$5=$6=$7=""; gsub("[\t]+","\t")}1' te_counts.txt > output_reduced.txt
````

### here we use ggplot2 to visualize the edgeR output into volcano plot

````
deg <- as.data.frame(ddx_P1[["table"]])
deg$sig <- "No Change"
deg$sig[deg$logFC > .1 | deg$logFC < -.1 & deg$FDR < .05] <- "Significant"
ggplot(deg, aes(x = logFC, y = -log(FDR, 10), col = sig)) +
  geom_point() +
  theme_classic()
````

![volcano_plot](https://user-images.githubusercontent.com/55756028/232490992-675bafc3-6a1f-4be9-b932-ae52213ae7bb.png)
