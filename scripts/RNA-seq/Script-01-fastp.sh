#!/bin/bash

WORKDIR=$1;
OUTPUT=${WORKDIR}/intermediate/fastp;
INPUT=${WORKDIR}/raw;
sample=$2; 

if [ ! -d ${OUTPUT} ]; 
then
	mkdir ${OUTPUT}
fi

sample1=`ls ${INPUT}/${sample}* | grep 1.fastq | awk -F "/" '{print $NF}'`
sample2=`ls ${INPUT}/${sample}* | grep 2.fastq | awk -F "/" '{print $NF}'`

fastp --thread 14 \
  --n_base_limit 5 \
  --qualified_quality_phred 15 \
  --compression 9 \
  --unqualified_percent_limit 40 \
  --length_required 25 \
  --complexity_threshold 50\
  --detect_adapter_for_pe \
  --complexity_threshold 1 \
  --trim_poly_x \
  --trim_poly_g \
  --adapter_fasta ${WORKDIR}/database/adapters.fa \
  --report_title "Sample_${sample}_fastp_report" \
  --html ${OUTPUT}/fastp-${sample}.html \
  --json ${OUTPUT}/fastp-${sample}.json \
  --in1 ${INPUT}/${sample1} \
  --out1 ${OUTPUT}/${sample1} \
  --in2 ${INPUT}/${sample2} \
  --out2 ${OUTPUT}/${sample2} > ${WORKDIR}/logs/${sample}-fastp.out 2>${WORKDIR}/logs/${sample}-fastp.err 

OUTPUT3=${WORKDIR}/intermediate/fastp/fastqc

if [ ! -d ${OUTPUT3} ];
then
        mkdir ${OUTPUT3}
fi

fastqc -o ${OUTPUT3} ${OUTPUT}/${sample1} ${OUTPUT}/${sample2} 2>${WORKDIR}/logs/fastqc-fastp-${sample}.log

if [ ! -d ${WORKDIR}/intermediate/fastqc ]; 
then
	mkdir ${WORKDIR}/intermediate/fastqc
fi

fastqc -o ${WORKDIR}/intermediate/fastqc ${INPUT}/${sample1} ${INPUT}/${sample2} 2>${WORKDIR}/logs/fastqc-${sample}.log


exit
