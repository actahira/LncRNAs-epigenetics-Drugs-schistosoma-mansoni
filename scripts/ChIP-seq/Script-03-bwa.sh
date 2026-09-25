#!/bin/bash

workdir=$1;
gendir=$2;
input="${workdir}/intermediate/02.fastp";
output="${workdir}/intermediate/03.bwa"
sample=$3;
bed="${gendir}/mito.bed"
index="${gendir}/schistosoma_mansoni.PRJEA36577.WBPS14.genomic";

fastq=`ls ${input}/${sample}.* | grep fastq`

if [ ! -d ${output} ]; 
then
	mkdir $output
fi

if [ ! -d ${output}/${sample} ];
then
        mkdir -p  ${output}/${sample};
fi

echo ${sample};


bwa-mem2 mem -M -t 8 -R "@RG\tID:${sample}\tLB:${sample}\tPL:illumina\tSM:${sample}" ${index} ${fastq}  -o ${output}/${sample}/Aligned.sam 2>${workdir}/logs/bwa-${sample}.log

samtools view --threads 8 -b -o ${output}/${sample}/Aligned.bam ${output}/${sample}/Aligned.sam
rm ${output}/${sample}/Aligned.sam


samtools flagstat ${output}/${sample}/Aligned.bam > ${output}/${sample}/Aligned.bam.flagstat

samtools view --threads 8 -F 0x904 -b ${output}/${sample}/Aligned.bam > ${output}/${sample}/Aligned.unique.bam

samtools flagstat ${output}/${sample}/Aligned.unique.bam > ${output}/${sample}/Aligned.unique.bam.flagstat

rm ${output}/${sample}/Aligned.bam


samtools view -b -L ${bed} -U ${output}/${sample}/Aligned.bam -o ${output}/${sample}/mito.bam ${output}/${sample}/Aligned.unique.bam

samtools sort --threads 8 -o ${output}/${sample}/input.bam ${output}/${sample}/Aligned.bam

picard-tools MarkDuplicates \
  I=${output}/${sample}/input.bam \
  O=${output}/${sample}/Aligned.unique.rm.bam \
  M=${output}/${sample}/Mark-stats-picard.txt REMOVE_DUPLICATES=true 2>${output}/${sample}/picard.log


rm ${output}/${sample}/Aligned.bam ${output}/${sample}/input.bam

samtools flagstat ${output}/${sample}/Aligned.unique.rm.bam > ${output}/${sample}/Aligned.unique.rm.bam.flagstat

exit
