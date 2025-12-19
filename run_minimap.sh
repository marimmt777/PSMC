!/bin/bash

#$ -q all.q
#$ -V
#$ -cwd
#$ -pe smp 20

module load minimap2/2.17
module load Samtools/1.22

samtools faidx PITSTA_inv_final_chroms.fasta

minimap2 -t $NSLOTS -L -x map-pb -a PITSTA_inv_final_chroms.fasta ../Pitcairnia_stamiena-ITA688_HiFi_80pM/CCS/m64041_221030_065348.hifi_reads.fastq.gz | samtools sort -o PITSTA_inv_final_chroms_PacBio.bam -O BAM
