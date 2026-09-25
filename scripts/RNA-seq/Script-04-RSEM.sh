#!/bin/bash

workdir=$1;
index=$2;
genome="schistosoma_mansoni.PRJEA36577.WBPS14.genomic_softmasked";
input="${workdir}/intermediate/star-alignment-2nd"
output="${workdir}/intermediate/star-alignment-2nd"; 
sample=$3; 

rsem-calculate-expression \
 --alignments \
 --paired-end \
 --no-bam-output \
 --strandedness reverse \
 -p 8 ${input}/${sample}/Aligned.toTranscriptome.out.bam \
 ${index}/${genome} ${output}/${sample}/sch_paired_end_quals \
 2> ${output}/${sample}/rsem.log

exit
