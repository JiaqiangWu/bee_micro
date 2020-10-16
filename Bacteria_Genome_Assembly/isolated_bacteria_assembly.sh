#!/bin/bash


#The command writes the script to run SOAPdenovo, which builds a de novo draft assembly.
perl soaptrans_scripts.pl -lst bacteria_list.txt -maxrl 150 -ins 350
sh bacteria_list.txt_soaptrans.sh

#An example of 'bacteria_list.txt_soaptrans.sh'
	#/home/tm/software/SOAPdenovo-Trans1.02/SOAPdenovo-Trans-127mer all -s P0219_config.txt -K 81 -p 16 -d 5 -t 1 -e 5 -o P0219
	#perl /home/tm/scripts/N50 P0219.scafSeq P0219_n50.txt 150


#It will rename .contig to .contig.fa.
cat bacteria_list.txt | while read line; do i=`echo $line|cut -d " " -f 1`; mv ${i}.contig ${i}.contig.fa;done 


#Minimap and BamDeal visualize the assembly file.
perl minimap_Bamdeal_scripts.pl -lst bacteria_list.txt
sh bacteria_list.txt_minimap_Bamdeal.sh

#An example of 'bacteria_list.txt_minimap_Bamdeal.sh'
	#/home/tm/software/minimap2-2.9/minimap2 -ax sr -t 24 P0219.scafSeq P0219_1.clean.fq.gz P0219_2.clean.fq.gz | samtools view -q 1 -b > P0219.bam
	#echo "P0219.bam" > P0219.bam.lst
	#/home/tm/software/BamDeal-0.19/BamDeal visualize DepthGC -Windows 100 -InList P0219.bam.lst -Ref P0219.scafSeq -OutPut P0219


#This command will filter scaffold.fasta by depth.
touch DepthGC_filter.txt    ##A list for min and max depth
perl asmfilter01_scripts.pl -lst bacteria_list.txt -dgc DepthGC_filter.txt
sh bacteria_list.txt_asmfilter01.sh

#An example of 'bacteria_list.txt_asmfilter01.sh'
	#perl depthGC_of_wig.pl P0219.DepthGC.wig.gz
	#perl asm_filter01.pl -asm P0219.scafSeq -dgc P0219.DepthGC -minD 300 -maxD 1300
