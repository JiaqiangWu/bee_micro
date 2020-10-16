#! /usr/bin/bash -w 

#This script will call germline SNPs and indels via local re-assembly of haplotypes for each sample.

usage()
{
    echo $0 '-i <input_folder> -o <output folder> -n  <number of threads> -t <inner_thread>'
}

thread=1	
inner_thread=1
Primary_DIR=$(pwd)
Script_DIR="$( cd "$( dirname "$0"  )" && pwd  )"
ref=AAscripts_ref/Amel_HAv3.1_genomic.fa
tmp_dir=~/tmp/  
while getopts "hi:o:n:t:" opt
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
        t)
		  inner_thread=$OPTARG;;
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
    bamfile=`ls $input_folder/$folder/*_unique.bam`
    echo  "working on $bamfile"
    mkdir  $output_folder/$folder
    #HaplotypeCaller --verbosity: INFO, WARNING, ERROR
    time gatk --java-options "-Xmx8g -XX:ParallelGCThreads=$inner_thread" HaplotypeCaller \
    --verbosity ERROR\
    --TMP_DIR $tmp_dir\
    -R $ref \
    -I $bamfile \
    -O $output_folder/$folder/${folder}.g.vcf.gz \
    -ERC GVCF \
    #--exclude-intervals                    
    echo "$bamfile done!"
    echo >&4 
    }& 
    sleep 1s 
fi
done <&4                   

wait                       
exec 4>&-                  
echo "All done!"
