#!/bin/bash

#This script will import single-sample GVCFs into GenomicsDB.
usage()
{
    echo $0 '-o <output folder> -m <sample-name-map> -n  <number of threads>'
}

thread=1	
Primary_DIR=$(pwd)
Script_DIR="$( cd "$( dirname "$0"  )" && pwd  )"
tmp=~/tmp
fai=AAscripts_ref/Amel_HAv3.1_genomic.fa.fai
while getopts "ho:m:n:" opt
do
	case $opt in
		h)
		  usage
		  exit 0;;
		i)
		  if [ -d "$OPTARG" ]
            then 
            echo '-i: '$OPTARG
            input_folder=$OPTARG
          else
            echo "$OPTARG dose not exit!"
            usage
            exit 0
          fi;;
        o)
        if [ -d "$OPTARG" ]
            then 
            echo '-o: '$OPTARG
            output_folder=$OPTARG
          else
            echo "$OPTARG dose not exit!"
            usage
            exit 0
          fi;;
        m)
        if [ -f "$OPTARG" ]
            then 
            echo '-m: '$OPTARG
            sample_name_map=$OPTARG
          else
            echo "$OPTARG dose not exit!"
            usage
            exit 0
          fi;;  
        n)
		  thread=$OPTARG;;  
		?)
		  echo "invalid option"
		  echo $OPTARG
		  exit 1;;
	esac
done



tmpfile=$$.fifo    
mkfifo $tmpfile    
exec 4<>$tmpfile   
rm $tmpfile        

{ 
for (( i = 1;i<=${thread};i++ )) 
do 
echo;                
done 
} >&4                

IFS=$'\n'
for line in `cat $fai` 
do
    read	 
    {
    echo $line
    scaffold=`echo $line | cut -f 1`
    echo $scaffold
    # --batch-size 6 
    time gatk --java-options "-Xmx8g -XX:ParallelGCThreads=1" \
    GenomicsDBImport \
       --TMP_DIR $tmp \
       --genomicsdb-workspace-path $output_folder/$scaffold \
       -L $scaffold \
       --sample-name-map $sample_name_map \
    && echo "$scaffold finished!"
    echo >&4 
    }& 
    
done <&4                   

wait                        
exec 4>&-                  
echo "All done!"
