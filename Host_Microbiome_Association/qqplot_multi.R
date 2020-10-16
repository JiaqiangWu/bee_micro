r=read.table("temp_name.txt")      
o=-log10(sort(r$V6,decreasing=F)) 
e=-log10(ppoints(length(r$V6)))    
plot(e,o,pch=20,xlab="Expected~-log10(p)",ylab="Observed~-log10(p)",main="QQ plot",col= "blue",xlim=c(0,max(e)+0.1),ylim=c(0,max(o)+0.1),bty= "l ",yaxs= "i ",xaxs= "i ",cex=2) 
abline(0,1,col= "red ")



setwd("/Users/wjq/Documents/mah/qqplot")
d <- read.csv("GF021-Fig.4-GWAS_refine_bifi122_glm_mlm_P.csv")

o=-log10(sort(d$Bifido_Amel_122.GLM,decreasing=F))
o2=-log10(sort(d$Bifido_Amel_122.MLM,decreasing = F))
e=-log10(ppoints(length(d$Bifido_Amel_122.GLM)))
pdf("QQ_plot_bifi122_glm_mlm.pdf")
svg("QQ_plot_bifi122_glm_mlm.svg", width=5, height=5)
png("QQ_plot_bifi122_glm_mlm.png", width=5, height=5)
plot(e,o,pch=16,xlab="Expected~-log10(p)",ylab="Observed~-log10(p)",
     main="QQ plot",col= "#C4AA49",xlim=c(0,max(e)+0.1),ylim=c(0,max(o)+0.1),
     bty= "l ",yaxs= "i ",xaxs= "i ",cex=1) 
abline(0,1,col= "red ")
points(e,o2,pch=16,col="#C5C0BF",cex=1)
dev.off()

##legend
legend(12,400,c("o","o2"),col=c("DarkTurquoise","DeepPink"),text.col=c("DarkTurquoise","DeepPink"),pch=c(15,16,17),lty=c(1,2,3))