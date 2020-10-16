setwd("heritability")

pheno <- read.table("mvp.QC_noP0_min05maf95.phe", header = T)
geno <- bigmemory::attach.big.matrix("mvp.QC_noP0_min05maf95.geno.desc")
geno.id <- read.table("mvp.QC_noP0_min05maf95.geno.ind", header = F)
#pedigree <- read.table("pedigree.txt", header = T)
map <- read.table("mvp.QC_noP0_min05maf95.geno.map", header = T)

R <- as.matrix(pheno$beecol)

gebv <- hiblup(pheno = pheno[, c(1, 17)], geno = geno, map = map, geno.id = geno.id, vc.method = c("HI"), R = R, mode = "A", snp.solution = TRUE)
