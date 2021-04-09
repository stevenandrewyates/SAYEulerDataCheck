##################################################
######            Details                   ######
##################################################

# author:   Steven Yates
# contact:  steven.yates@usys.ethz.ch
# Year:     2021
# Citation: TBA

##################################################
######            Description               ######
##################################################

# A sh script for running fastqc on multiple files, 
# contained in a directory
# please find more information here

# https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

##################################################
######              Usage                   ######
##################################################

# sh 02_FastqcAFolder.sh -f FASTQ

##################################################
######              Script                  ######
##################################################

while getopts f: flag
do
    case "${flag}" in
        f) Example=${OPTARG};;
    esac
done

echo "loading java";
module load java
echo "Path: $Example";

echo "Making directory: FASTQC";
mkdir FASTQC

echo "Running fastqc on all files in the folder: $Example";
for x in $(ls $Example); do echo $SCRATCH/FastQC/fastqc $Example/$x --outdir=FASTQC;done | bash

echo "Done :)";
