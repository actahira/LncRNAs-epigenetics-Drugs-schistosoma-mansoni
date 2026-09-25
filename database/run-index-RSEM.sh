WORKDIR=$1;
GTF="transcriptome_v7.gtf";
REF="schistosoma_mansoni.PRJEA36577.WBPS14.genomic_softmasked";
MAP="geneid2transcripts.txt";

if [ ! -f "schistosoma_mansoni.PRJEA36577.WBPS14.genomic_softmasked.fa" ]
then
	wget https://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS14/species/schistosoma_mansoni/PRJEA36577/schistosoma_mansoni.PRJEA36577.WBPS14.genomic_softmasked.fa.gz
	gunzip schistosoma_mansoni.PRJEA36577.WBPS14.genomic_softmasked.fa.gz
fi


rsem-prepare-reference \
 --gtf $WORKDIR/${GTF} \
 --transcript-to-gene-map ${WORKDIR}/${MAP} \
 --star -p 20  ${WORKDIR}/${REF}.fa ${WORKDIR}/${REF} 2> ${WORKDIR}/index-rsem.log
