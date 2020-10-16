#!/bin/bash

#This command will include the individuals in subsequent analysis.
vcftools --vcf 06clean_vcf/raw_pop_min05maf95 \
--keep hybrid_founding_keeplist \
--recode \
--recode-INFO-all \
--out 08subhy/hyf

#This part will output the genotype data in PLINK PED format. Two files are generated, with suffixes ".ped" and ".map" and only bi-allelic loci will be output. 
vcftools --vcf hyf.recode.vcf --plink --out hyf

#PLINK perform the quality control.
plink --noweb --file hyf --geno 0.05 --maf 0.05 --hwe 0.0001 --make-bed --out QC_hyf

#This will ran ADMIXTURE with cross-validation for K values from 1 to 8.
for K in {1..8} ;do admixture --cv QC_hyf.bed $K -j20 | tee admixture_QC_hyf_${K}.log; done

#This will view the CV errors.
grep -h CV admix*.log >CV_hyf.txt