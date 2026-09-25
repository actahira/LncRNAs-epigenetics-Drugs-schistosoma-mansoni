#!/bin/bash


WORKDIR=$1
OUTPUT=${WORKDIR}/intermediate/02.fastp
INPUT=${WORKDIR}/intermediate/01.cutadapt
DIR=$2;
layout=$3; 
OUTPUT3=${WORKDIR}/intermediate/02.fastp-fastqc

if [ ! -d ${OUTPUT} ];
then
        mkdir ${OUTPUT}
fi

if [ ! -d ${OUTPUT3} ];
then
        mkdir ${OUTPUT3}
fi


if [[ "${layout}" == "single" ]]
then
	sample=`ls ${INPUT}/${DIR}* | grep fastq | awk -F "/" '{print $NF}'`

	fastp --thread 8 \
		--n_base_limit 5 \
		--qualified_quality_phred 15 \
		--unqualified_percent_limit 40 \
		--length_required 30 \
		--low_complexity_filter \
		--complexity_threshold 50\
		--trim_poly_x \
		--trim_poly_g \
		--poly_x_min_len 5 \
		--report_title "Sample_${DIR}_fastp_report" \
		--html ${OUTPUT}/fastp-${DIR}.html \
		--json ${OUTPUT}/fastp-${DIR}.json \
		--in1 ${INPUT}/${sample} \
		--out1 ${OUTPUT}/${sample} > ${WORKDIR}/logs/${DIR}-fastp.out 2>${WORKDIR}/logs/${DIR}-fastp.err 

	fastqc -o ${OUTPUT3} ${OUTPUT}/${sample}  2>${WORKDIR}/logs/fastqc-fastp-${DIR}.log

else
	in1=`ls ${INPUT}/${DIR}* | grep 1.fastq | awk -F "/" '{print $NF}'`
	in2=`ls ${INPUT}/${DIR}* | grep 2.fastq | awk -F "/" '{print $NF}'`

	fastp --thread 8 \
        	--n_base_limit 5 \
	        --detect_adapter_for_pe \
        	--qualified_quality_phred 15 \
	        --unqualified_percent_limit 40 \
        	--length_required 30 \
	        --complexity_threshold 50\
        	--trim_poly_x \
	        --trim_poly_g \
        	--poly_x_min_len 5 \
        	--report_title "Sample_${DIR}_fastp_report" \
	        --html ${OUTPUT}/fastp-${DIR}.html \
	        --json ${OUTPUT}/fastp-${DIR}.json \
		--in1 ${INPUT}/${in1} \
		--in2 ${INPUT}/${in2} \
		--out1 ${OUTPUT}/${in1} \
		--out2 ${OUTPUT}/${in2} > ${WORKDIR}/logs/${DIR}-fastp.out 2>${WORKDIR}/logs/${DIR}-fastp.err 

	fastqc -o ${OUTPUT3} ${OUTPUT}/${in1}  2>${WORKDIR}/logs/fastqc-fastp-${in1}.log

	fastqc -o ${OUTPUT3} ${OUTPUT}/${in2}  2>${WORKDIR}/logs/fastqc-fastp-${in2}.log

fi

exit
