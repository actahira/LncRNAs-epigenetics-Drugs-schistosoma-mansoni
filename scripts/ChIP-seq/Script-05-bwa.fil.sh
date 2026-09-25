#!/bin/bash


workdir=$1; 
input="${workdir}/intermediate/03.bwa";
output="${workdir}/intermediate/05.bwa-filt"
sample=$2;
bio=$3;
bed="${workdir}/intermediate/04.macs3_blacklist_${bio}/black.list.bed"

if [ ! -d ${output} ]; 
then
	mkdir $output
fi

if [ ! -d ${output}/${sample} ];
then
	mkdir -p  ${output}/${sample}; 
fi


echo ${sample};

if [ -s ${output}/${sample}/blacklist.bam ]
then

	cp ${input}/${sample}/Aligned.unique.rm.bam ${output}/${sample}/Aligned.bam

else
	samtools view -b -L ${bed} \
		-U ${output}/${sample}/Aligned.bam \
		-o ${output}/${sample}/blacklist.bam \
		${input}/${sample}/Aligned.unique.rm.bam

	samtools flagstat ${output}/${sample}/Aligned.bam > ${output}/${sample}/Aligned.bam.flagstat

	samtools flagstat ${output}/${sample}/blacklist.bam > ${output}/${sample}/blacklist.bam.flagstat
fi
exit
