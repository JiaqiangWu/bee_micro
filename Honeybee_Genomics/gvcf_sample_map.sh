#!/bin/bash
usage()
{
    echo $0 '-i <input_folder>'
}

thread=1	
Primary_DIR=$(pwd)
Script_DIR="$( cd "$( dirname "$0"  )" && pwd  )"

while getopts "hi:" opt
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

cat /dev/null > $input_folder/sample_map.txt 
for folder in `ls $input_folder`
do
    if [ -d "$input_folder/$folder" ]
    then
        abs_path=`readlink -f $input_folder/$folder` 
        echo -e ${folder}"\t"$abs_path/${folder}.g.vcf.gz >> $input_folder/sample_map.txt 
    fi
done

echo "done!"

