#!/bin/bash

workdir=$1; 
input="${workdir}/intermediate/05.bwa-filt";
output="${workdir}/intermediate/06.macs3"
sample=$2; 
g="406876116"
layout=$3;
c1=$4

if [ ! -d ${output} ]; 
then
	mkdir $output
fi


echo ${sample};

if [[ "${layout}" == "single" ]]
then
	macs3 callpeak \
		-t ${input}/${sample}/Aligned.bam \
		-c ${input}/${c1}/Aligned.bam \
		--broad -g ${g} --broad-cutoff 0.1 \
		--nomodel --extsize 147 \
		--llocal 10000 --slocal 4000 \
		-n ${output}/${sample} 2>${workdir}/logs/macs3-${sample}
else

        macs3 callpeak -f BAMPE \
                -t ${input}/${sample}/Aligned.bam \
		-c ${input}/${c1}/Aligned.bam \
                --broad -g ${g} --broad-cutoff 0.1 \
                --nomodel --extsize 147 \
                --llocal 10000 --slocal 4000 \
                -n ${output}/${sample} 2>${workdir}/logs/macs3-${sample}
fi
		
exit
