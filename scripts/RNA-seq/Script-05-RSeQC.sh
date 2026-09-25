#!/bin/bash

workdir=$1;
ref="$2/transcriptome_v7.bed";
input="${workdir}/intermediate/star-alignment-2nd";
output="${workdir}/schisto_all_drugs/intermediate/star-alignment-2nd"; 
sample=$3; 


cd ${input}/${sample}

samtools index -@ 10 -b Aligned.sortedByCoord.out.bam

tin.py -i Aligned.sortedByCoord.out.bam -r ${ref}

geneBody_coverage.py -i Aligned.sortedByCoord.out.bam -r ${ref} -o geneBody_

cd ~

exit
