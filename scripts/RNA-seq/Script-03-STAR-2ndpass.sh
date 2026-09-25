#!/bin/bash

workdir=$1; 
input="${workdir}/intermediate/fastp"; 
output="${workdir}/intermediate/star-alignment-2nd"; 
ref="${workdir}/intermediate/star-alignment"
index=$2;
sample=$3; 

if [ ! -d ${output} ];
then
	mkdir ${output}
fi

if [ ! -d ${output}/${sample} ];
then
        mkdir ${output}/${sample}
fi


A1=`ls ${input}/${sample}_* | grep 1.fastq$`; 
A2=`ls ${input}/${sample}_* | grep 2.fastq$`;

STAR --runThreadN 14 \
  --genomeDir ${index} \
  --readFilesIn ${A1} ${A2} \
  --runMode alignReads \
  --outFilterType BySJout \
  --outFilterMultimapNmax 20 \
  --alignSJoverhangMin 8 \
  --alignSJDBoverhangMin 3 \
  --outFilterMismatchNoverReadLmax 0.30 \
  --alignIntronMin 20 \
  --alignIntronMax 1000000 \
  --alignMatesGapMax 1000000 \
  --outSAMtype BAM SortedByCoordinate \
  --outFileNamePrefix ${output}/${sample}/ \
  --outReadsUnmapped Fastx \
  --quantMode TranscriptomeSAM \
  --quantTranscriptomeBAMcompression 10 \
  --sjdbFileChrStartEnd ${ref}/${sample}/SJ.out.tab

exit
