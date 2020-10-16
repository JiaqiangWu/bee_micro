#! /usr/bin/bash -w 

###Prepare workspace
cd genetic_workspace
mkdir 01cleanfq 02bam 03gvcf 04DB 05popvcf 06clean_vcf 07subp 08subhy 09gwas 

###Preprocessing for FastQ files
for i in `ls 00rawdata/*_1.fq.gz`
do
	j=`basename $i`
	fastp -i ${i} \
	-I ${i%1.fq.gz}2.fq.gz \
	-o 01cleanfq/${j%_1.fq.gz}_R1_fastpout.fq.gz \
	-O 01cleanfq/${j%_1.fq.gz}_R2_fastpout.fq.gz \
	-j 01cleanfq/${j%_1.fq.gz}.json \
	-h 01cleanfq/${j%_1.fq.gz}.html \
	-w 15
done

##Software_dependency
#fastp -v
#fastp: an ultra-fast all-in-one FASTQ preprocessor
#version 0.13.1

###This part will download the reference fasta file and index sequences.
cd genetic_workspace
cd AAscripts_ref
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/003/254/395/GCA_003254395.2_Amel_HAv3.1/GCA_003254395.2_Amel_HAv3.1_genomic.fna.gz
bwa index -a bwtsw GCA_003254395.2_Amel_HAv3.1_genomic.fna.gz


###This part will make the sample file.
cd ../01cleanfq
ls *_R1_fastpout.fq.gz >sample_list.txt
sed -i 's/_R1_fastpout.fq.gz//g' sample_list.txt 
mv sample_list.txt AAscripts_ref/sample_list.txt


###This part will map reads to the referenc and sum the BAM files.
cd ..
cat AAscripts_ref/sample_list.txt | while read line 
do 
        #mapping, sorting and compatibling with Picard
        bwa mem -v 1 -t 4 -R "@RG\tID:$line\tPU:$line\tLB:$line\tPL:ILLUMINA\tSM:$line" \
         -M AAscripts_ref/GCA_003254395.2_Amel_HAv3.1_genomic.fna.gz \
         01cleanfq/${line}_R1_fastpout.fq.gz 01cleanfq/${line}_R2_fastpout.fq.gz 2>/dev/null \
         |picard -Xmx4g -XX:ParallelGCThreads=4 -Djava.io.tmpdir=~/tmp SortSam \
                I=/dev/stdin \
                O=02bam/${line}_sorted.bam \
                SORT_ORDER=coordinate \
                CREATE_INDEX=true \
                VERBOSITY=WARNING

#This command will remove duplicate alignments from a coordinate sorted file.
samtools rmdup 02bam/${line}_sorted.bam 02bam/${line}_markdup.bam &&rm 02bam/${line}_sorted.bam 

#This will skip alignments with MAPQ smaller than 1.
samtools view -q 1 02bam/${line}_markdup.bam -o 02bam/${line}_unique.bam &&rm 02bam/${line}_markdup.bam  #unique     

#This will do a full pass through the input file to calculate and print statistics.
samtools flagstat 02bam/${line}_unique.bam > 02bam/${line}_stat.txt

#Samtools stats collects statistics from BAM files.
samtools stats 02bam/${line}_unique.bam > 02bam/${line}_stats.txt

#This command will index BAM files for following analysis. 
samtools index 02bam/${line}_unique.bam

done
