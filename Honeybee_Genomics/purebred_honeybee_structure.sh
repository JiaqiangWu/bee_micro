#!/bin/bash

#This command will include the individuals in subsequent analysis.
vcftools --vcf 06clean_vcf/raw_pop_min05maf95 \
--keep pure57_keeplist \
--recode \
--recode-INFO-all \
--out 07subp/pure57

#This part will output the genotype data in PLINK PED format. Two files are generated, with suffixes ".ped" and ".map" and only bi-allelic loci will be output. 
vcftools --vcf pure57.recode.vcf --plink --out pure57

#PLINK perform the quality control.
plink --noweb --file pure57 --geno 0.05 --maf 0.05 --hwe 0.0001 --make-bed --out QC_pure57

#This will ran ADMIXTURE with cross-validation for K values from 1 to 8.
for K in {1..8} ;do admixture --cv QC_pure57.bed $K -j20 | tee admixture_QC_pure57_${K}.log; done

#This will view the CV errors.
grep -h CV admix*.log >CV_pure57.txt


##This part will estimate a tree using the neighbor-joining.
vcftools --vcf 06clean_vcf/raw_pop_min05maf95 \
--keep pure57+cera_keeplist \
--recode \
--recode-INFO-all \
--out 07subp/pure57+cera

Rscript tree.R


#The populations program will compare all populations pairwise to compute FST.
populations -V ../QC_pure57.recode.vcf -M pure57_spe_pop_map.txt -O ./ -p 2 --fstats -k --sigma 100000 -t 32 >stack_beespe_pure57_population.log