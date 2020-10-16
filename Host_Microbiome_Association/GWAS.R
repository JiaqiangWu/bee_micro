###GWAS(R)
library(rMVP)
setwd("")

MVP.Data(fileBed="QC_pop_min05maf95",
         filePhe="mvp_phefile.txt",
         fileKin=FALSE,
         filePC=FALSE,
         out="mvp",         
         priority="speed"
         #maxLine=10000,
)
genotype <- attach.big.matrix("mvp.geno.desc")
phenotype <- read.table("mvp.phe",head=TRUE)
map <- read.table("mvp.geno.map" , head = TRUE)


for(i in 2:ncol(phenotype)){
  imMVP <- MVP(
    phe=phenotype[, c(1, i)],
    geno=genotype,
    map=map,
    #K=Kinship,
    #CV.GLM=Covariates,
    #CV.MLM=Covariates,
    #CV.FarmCPU=Covariates,
    nPC.GLM=5,
    nPC.MLM=3,
    nPC.FarmCPU=3,
    priority="memory",
    ncpus=30,
    vc.method="HE",
    maxLoop=10,
    method.bin="FaST-LMM",#"FaST-LMM","EMMA", "static"
    #permutation.threshold=TRUE,
    #permutation.rep=100,
    threshold=0.1,
    method=c("GLM", "MLM", "FarmCPU")
  )
  gc()
}

