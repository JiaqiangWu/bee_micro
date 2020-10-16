#!/usr/bin Rscript

setwd("~/genetic_workspace/07subp")
rm(list=ls())
library(gdsfmt)
library(SNPRelate)
library(ggplot2)
library(ape)


snpgdsVCF2GDS("pure57+cera.recode.vcf","clean.gds")

genofile = snpgdsOpen("clean.gds")

sample_info=read.csv("pure57+cera_tree_sample.csv")

sample.id=sample_info$Sample_ID


snpset <- snpgdsLDpruning(genofile,
                          sample.id=sample.id,
                          method = "corr",slide.max.n = 50, 
                          ld.threshold=0.2, autosome.only=FALSE)

ibs <- snpgdsIBS(genofile,autosome.only = F,sample.id=sample.id,snp.id=unlist(snpset))
ibs_matrix <- 1-ibs$ibs
rownames(ibs_matrix) <- sample_info$rename_tree

tree <-nj(ibs_matrix)
#tree <-njs(ibs_matrix)
plot(tree)
write.tree(tree,file="pure57.tre")