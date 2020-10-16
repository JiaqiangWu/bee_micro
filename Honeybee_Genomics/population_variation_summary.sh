#!/bin/bash


#This command will concat vcfs.
ls 05popvcf/*vcf.gz >vcfs_list.txt
bcftools concat -f vcfs_list.txt -O z -o 06clean_vcf/raw_pop.vcf.gz --threads 32


#The raw VCF dataset filterred by min/max allele freq cut-off (5% and 95%).
vcftools --gzvcf 06clean_vcf/raw_pop.vcf.gz \
--maf 0.05 \
--max-maf 0.95 \
--remove-indels \
--recode \
--recode-INFO-all \
--out 06clean_vcf/raw_pop_min05maf95


#This command will summarize the VCF dataset.
java -jar ~/DISCVRSeq-1.13.jar VariantQC \
-O 06clean_vcf/raw_pop_min05maf95_VariantQC.html \
-R AAscripts_ref/Amel_HAv3.1_genomic.fa \
-V 06clean_vcf/raw_pop_min05maf95.vcf.gz


#This command will calculate SNP density.
vcftools --gzvcf raw_pop_min05maf95.vcf.gz --SNPdensity 100000