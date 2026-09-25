#!/bin/bash


workdir=$1; 
input="${workdir}/raw";
output="${workdir}/intermediate/01.cutadapt"
dir=$2; 
layout=$3;

if [ ! -d ${output} ]; 
then
	mkdir $output
fi

echo ${sample};

# PLEASE MAKE SURE THAT CONDA ENVIRONMENT IS ACTIVATED
#conda activate cuptadapt

if [[ "${layout}" == "single" ]]
then
        sample=`ls ${input}/${dir}* | grep fastq | awk -F "/" '{print $NF}'`

	cutadapt -a GATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
		 -a AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT \
		 ${input}/${sample} \
		 -O 4 -e 0.3 -m 30 \
		 -o ${output}/${sample} > ${workdir}/logs/cutadpt-${sample}

else

        in1=`ls ${input}/${dir}* | grep 1.fastq | awk -F "/" '{print $NF}'`
        in2=`ls ${input}/${dir}* | grep 2.fastq | awk -F "/" '{print $NF}'`

	cutadapt -a AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT \
        	 -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
		 -O 4 -e 0.3 -m 30 \
		 -o ${output}/${in1} -p ${output}/${in2} \
		 ${input}/${in1} ${input}/${in2} > ${workdir}/logs/cutadpt-${dir}
fi

exit
