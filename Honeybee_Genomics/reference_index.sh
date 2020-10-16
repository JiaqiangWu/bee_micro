#!/bin/bash


#This part will prpare reference and index for following analysis.
cd AAscripts_ref
gzip -dc GCA_003254395.2_Amel_HAv3.1_genomic.fna.gz > Amel_HAv3.1_genomic.fa
samtools faidx Amel_HAv3.1_genomic.fa
gatk CreateSequenceDictionary -R Amel_HAv3.1_genomic.fa -O Amel_HAv3.1_genomic.dict && echo "** dict done **"

