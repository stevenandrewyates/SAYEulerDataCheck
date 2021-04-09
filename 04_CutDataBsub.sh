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

# A sh script for cutting the data you want for a 
# fastq files. This script sends the jobs to the 
# batch submission (bsub) system.

# this has three inputs
# -f the directory with the fastq data in
# -o the directory to output the data to
# -l the length of the reads to retain

##################################################
######              Usage                   ######
##################################################

# sh 03_CutData.sh -f FASTQ -o CLEAN -l 85

##################################################
######              Script                  ######
##################################################

while getopts l:o:f: flag
do
    case "${flag}" in
        f) FASTQ=${OPTARG};;
        o) CLEAN=${OPTARG};;
        l) LEN=${OPTARG};;
    esac
done
echo "Input folder: $FASTQ";
echo "Output folder: $CLEAN";
echo "Read length: $LEN";

echo "Making folder: $CLEAN";
mkdir $CLEAN

echo "Processing files";
for x in $(ls $FASTQ); do echo "bsub cat $FASTQ/$x | cut -c 1-$LEN > $CLEAN/$x";done |  bash

echo "Done :)";
