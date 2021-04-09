# SAYEulerDataCheck
Tools to quality check, clean and trim fastq data.

# Quality checking

Before getting started with your data you may want to check its quality. This can be done easily and very colorfully using fastqc. Found at: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/. To get this running on Euler we can use the following:

First navigate to your scratch directory (`cd $SCRATCH`), load java (`module load`), download (`wget`) then `unzip` fastqc and make it executable (`chmod 755`)

```
cd $SCRATCH
module load java
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
unzip fastqc_v0.11.9.zip
chmod 755 FastQC/fastqc
```
Now everything is ready to use and you can check the installation using 

```
FastQC/fastqc --help
```

To check your data we will first make a directory to store the database

```
mkdir FASTQC
```

Then you can easily check fastq files using the following

```
FastQC/fastqc input.fastq –outdir=FASTQ
```

This will generate a html output file that needs downloading from Euler and can be viewed in a web browser.

However you probably want to do this lots of times? This is easy if you have all of your fastq data in a directory: like FASTQ. You can then make a simple `for` loop to do this. In the example below the contents of the directory FASTQ `x in $(ls FASTQ)` are used as input to the for loop. This will then write the commands ‘do echo’. Finally we send the commands to Euler using a pipe `| bash`. I find this useful to check the commands before running them (omit the `| bash`).

```
for x in $(ls FASTQ); do echo FastQC/fastqc FASTQ/$x --outdir=FASTQC;done | bash
``` 
Perhaps you really have lots of these and want to use the batch submission system for this. In this case just add this in the echo 

```
for x in $(ls FASTQ); do echo bsub FastQC/fastqc FASTQ/$x --outdir=FASTQC;done | bash
```

# Cleaning fastq data

So the report doesn’t look good, the last ten bases are bad. What can you do. You have two options first is simply to cut out the data you want, second use a program to do this for you.

I prefer the first option. Just use the `cut` command, in the example below we will select only the first 85 bases `-c1-85` and write the output to a new directory `mkdir CLEAN’

```
mkdir CLEAN
cat FASTQ/input.fastq | cut -c1-85 > CLEAN/input.fastq
```

This can easily automated `for` all files in the FASTQ directory `x in $(ls FASTQ)` 

```
for x in $(ls FASTQ); do echo "cat FASTQ/$x | cut -c 1-85 > CLEAN/$x";done |  bash
```

If you prefer you can send all the work to the batch submission. Normally this should is easy, because read/write speed is the time limiting factor: which isn’t an issue on a server

```
for x in $(ls FASTQ); do echo "bsub cat FASTQ/$x | cut -c 1-85 > CLEAN/$x";done |  bash
```

Now let’s suppose not all the data is bad, just the second read. So you don’t want to lose data from the first read. This can be done by only selecting files from the second read. An easy way to do this is use a pattern match (`grep`) and we just need to modify the input like so:

```
for x in $(ls FASTQ | grep .2.fastq); do echo "bsub cat FASTQ/$x | cut -c 1-85 > CLEAN/$x";done |  bash
```

However this will only place data from the second read in the CLEAN directory. So we need an extra process to copy the first read also to the CLEAN directory, like so:

```
for x in $(ls FASTQ | grep .1.fastq); do echo "bsub cp FASTQ/$x CLEAN/$x";done |  bash
```
# Example

In the example below we will first download the 1,000 reads from the SRA for six Cassava samples: in the directory `cassava`. 
```
Directory=cassava
module load git
git clone https://github.com/stevenandrewyates/SAYEulerDataManagement
sh $SCRATCH/SAYEulerDataManagement/01_DownloadSRAtoolkit.sh
sh $SCRATCH/SAYEulerDataManagement/02_DownloadCassavaSix.sh -f $Directory -n 1000
```

If you already have some data don't worry, you can skip the above.

Next we will run the code on the `$Directory`. Please make sure you specify this, like above or use an explicit path "/cluster/scratch/user/cassava". Also remember that to specify the folder with the fastq data in when calling `SAYEulerDataCheck/02_FastqcAFolder.sh` by using `-f FASTQ`.

```
git clone https://github.com/stevenandrewyates/SAYEulerDataCheck
sh $SCRATCH/SAYEulerDataCheck/01_DownloadFastqc.sh
cd $Directory
sh $SCRATCH/SAYEulerDataCheck/02_FastqcAFolder.sh -f FASTQ
```
Next we will select only the first 85 bp in the data. You can either run this live on the terminal,

```
sh $SCRATCH/03_CutData.sh -f FASTQ -o CLEAN -l 85
```
or using the bsub system.
```
sh $SCRATCH/04_CutDataBsub.sh -f FASTQ -o CLEAN -l 85
```
