#! /usr/bin/bash -w 

#This script will characterize the insolated bacteria genome and provide evidence for the classification of species at the strain level.

#This step will calculate genome completeness. 
ls ./bacteria_fa >bacteria.list #The bacteria.list listted the genomes.
checkm lineage_wf -f checkm_out --tab_table -t 4 --pplacer_threads 4 -x fa ./bacteria_fa/ 


#The command performs computation of whole-genome Average Nucleotide Identity (ANI).
./fastANI --ql bacteria.list --rl bacteria.list -o bacteria.ani


#Prokka performs whole genome annotation.
for i in $(cat bacteria.list)
do
	prokka ${i} --kingdom Bacteria --outdir ${i%.fna} --locustag ${i%.fna} --prefix ${i%.fna}
done

#K number assignment based on KO-dependent scoring criteria.
for i in `ls */*.faa`
do
	KofamScan/exec_annotation -o ${i%.faa}_kofam.txt ${i} --profile prokaryote.hal
done 


#PhyloPhlAn reconstruct strain-level phylogenies using clade-specific maximally informative phylogenetic markers.
for g in Bifido Gilli Barto Firm5 Firm4 Snod
do
	./phylophlan.py -u ${g} --nproc 4
done 
