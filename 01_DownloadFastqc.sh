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

# A sh script for downloading the fastqc program
# please find more information here

# https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

# This will happen in your $SCRATCH folder. 

##################################################
######              Usage                   ######
##################################################

# sh 01_DownloadSRAtoolkit.sh

##################################################
######              Script                  ######
##################################################

echo "Changing directory to: $SCRATCH";
cd $SCRATCH

echo "loading java module";
module load java

echo "Downloading data";
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip

echo "Unzipping data";
unzip fastqc_v0.11.9.zip
chmod 755 FastQC/fastqc

echo "Checking it is executable";
FastQC/fastqc --help

echo "Done :)";
