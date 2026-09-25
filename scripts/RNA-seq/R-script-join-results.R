# Fetch all arguments passed after the script name
args <- commandArgs(trailingOnly = TRUE)

# Test if there is at least one argument
if (length(args) == 0) {
  stop("At least one argument must be supplied", call. = FALSE)
}

wd <- args[1]
wr <- args[2]

setwd(wd)

type <- c("isoforms", "genes")

for (a in type){
 dir("./", "SRR") -> files
 file <- paste("/sch_paired_end_quals.", a, ".results", sep="")
 files <- paste (files ,file, sep="")
 files
 final <- NULL
 final2 <- NULL

 for (i in files){
  read.delim(i) -> tmp
  ifelse (a %in% "isoforms", "transcript_id", "gene_id") -> n
  tmp[,c(n,"expected_count")]-> tmp1
  tmp[,c(n,"TPM")]-> tmp
  if(is.null(final))
  {
    final <- tmp
    final2 <- tmp1
  } else {
    merge(final, tmp, by=1) -> final
    merge(final2, tmp1, by=1) -> final2
  }
  colnames(final)[ncol(final)] <- i
  colnames(final2)[ncol(final2)] <- i
  } 
  gsub(file, "", colnames(final)) -> colnames(final)
  gsub(file, "", colnames(final2)) -> colnames(final2)
  head(final)

  write.table(final, paste(wr, "/Table-", a, "-tpm.txt", sep=""), sep="\t", row.names = F, quote=F)
  write.table(final2, paste(wr, "/Table-", a, "-counts.txt", sep=""), sep="\t", row.names = F, quote=F)

}
