#!/bin/bash

#This script will perform joint genotyping on samples pre-called with HaplotypeCaller.
usage()
{
    echo $0 '-i <input_folder> -o <output folder> -n <number of threads>'
}

thread=1	
Primary_DIR=$(pwd)
Script_DIR="$( cd "$( dirname "$0"  )" && pwd  )"
ref=AAscripts_ref/Amel_HAv3.1_genomic.fa
tmp=~/tmp/
while getopts "hi:o:n:" opt
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

for folder in `ls $input_folder`
do

if [ -d "$input_folder/$folder" ]
then
    read	 
    {
    echo $folder
    mkdir $output_folder/$folder
    
    time gatk --java-options "-Xmx8g -XX:ParallelGCThreads=1" GenotypeGVCFs \
    -R $ref \
    --TMP_DIR $tmp \
    -new-qual \
    -V gendb://$input_folder/$folder \
    -O $output_folder/$folder/${folder}.vcf.gz \
    && echo "$folder finished!"
    echo >&4 
    }& 
    
fi
done <&4                   

wait                       
exec 4>&-                  
echo "All done!"
