#=====================================================================================
#  Load package
#=====================================================================================
library(DESeq2)

#=====================================================================================
#  Import data
#=====================================================================================
path <- '~/deseq-local'
setwd(path)
count_data <- read.table('../gene_count_matrix.csv',header = T, sep = ",", row.names = 1)
count_data <- as.matrix(count_data)
count_data[is.na(count_data)] <- 0

#=====================================================================================
#  DESeq2 analysis
#=====================================================================================
condition <- factor(c("Bi", "Bi", "Bi",
                      "GF", "GF", "GF"))
dds <- DESeqDataSetFromMatrix(count_data, DataFrame(condition), design= ~condition )
dds <- estimateSizeFactors(dds)
dds <- estimateDispersions(dds,fitType = 'local')
dds <- nbinomWaldTest(dds)
norm <- counts(dds, normalized=TRUE)
write.csv(norm,'./gene_deseq_norm.csv')
control <- 'GF'
test <- 'Bi'
res <- results(dds,contrast=c("condition",test,control))
write.csv(res,'./gene_Bi-GF.csv')
