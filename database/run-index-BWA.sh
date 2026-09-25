WORKDIR=$1;
REF="schistosoma_mansoni.PRJEA36577.WBPS14.genomic";

if [ ! -f "schistosoma_mansoni.PRJEA36577.WBPS14.genomic.fa" ]
then
	wget https://ftp.ebi.ac.uk/pub/databases/wormbase/parasite/releases/WBPS14/species/schistosoma_mansoni/PRJEA36577/schistosoma_mansoni.PRJEA36577.WBPS14.genomic.fa.gz
	
	gunzip schistosoma_mansoni.PRJEA36577.WBPS14.genomic.fa.gz
fi

bwa-mem2 index -p  ${REF} ${REF}.fa

