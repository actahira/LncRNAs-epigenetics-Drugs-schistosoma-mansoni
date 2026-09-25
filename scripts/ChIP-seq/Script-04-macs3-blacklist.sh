#!/bin/bash

workdir=$1; 
input="${workdir}/intermediate/03.bwa";
sample=$2;
bio=$3;
output="${workdir}/intermediate/04.macs3_blacklist_${bio}";
gsize="409579008"; #409579008-26917 (genome - chMITO)
readsize="75";
q="0.0000000001";
layout=$4;

# parameters are based on GreenScreen paper

if [ ! -d ${output} ]; 
then
	mkdir $output
fi

if [ ! -d ${output}/${sample} ]; 
then
	mkdir -p  ${output}/${sample}; 
fi

echo ${sample};

# call peaks with MACS3
if [[ "${layout}" == "single" ]]
then
	macs3 callpeak \
		-t ${input}/${sample}/Aligned.unique.rm.bam \
		-f BAM --keep-dup auto --nomodel -q ${q} \
		--extsize ${readsize} --broad --nolambda \
		-g ${gsize} -n input${sample} \
		--outdir ${output}/${sample} 2>${workdir}/logs/macs3-blacklist-${sample}.log;
else
	macs3 callpeak -f BAMPE \
        	-t ${input}/${sample}/Aligned.unique.rm.bam \
	        -f BAM --keep-dup auto --nomodel -q ${q} \
        	--extsize ${readsize} --broad --nolambda \
	        -g ${gsize} -n input${sample} \
        	--outdir ${output}/${sample} 2>${workdir}/logs/macs3-blacklist-${sample}.log
fi
	
exit
