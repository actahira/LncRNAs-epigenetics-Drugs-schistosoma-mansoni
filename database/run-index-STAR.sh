#!/bin/bash

workdir=$1; 
genome="schistosoma_mansoni.PRJEA36577.WBPS14.genomic_softmasked.fa";
gtf="transcriptome_v7.gtf";

if [ ! -f "schistosoma_mansoni.PRJEA36577.WBPS14.genomic_softmasked.fa" ]
then
        wget https://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS14/species/schistosoma_mansoni/PRJEA36577/schistosoma_mansoni.PRJEA36577.WBPS14.genomic_softmasked.fa.gz
        gunzip schistosoma_mansoni.PRJEA36577.WBPS14.genomic_softmasked.fa.gz
fi


STAR --runThreadN 8 \
	--runMode genomeGenerate \
	--genomeDir ${workdir} \
	--genomeFastaFiles ${workdir}/${genome} \
	--sjdbGTFfile ${workdir}/${gtf} \
	--genomeSAindexNbases 13 \
	--sjdbOverhang 99

exit
