#install.packages("forestplot")

library(ggplot2)
setwd("/Users/mac/Documents/Genetic/Scripts/Genetic_R_Project/heritability_bar")

sample <- read.csv("/Users/mac/Documents/Genetic/Data/G009_GWAS/heritability_final.csv")


sample<-data.frame(sample,stringsAsFactors=FALSE)
sample[,2]<-as.numeric(sample[,2])
sample[,3]<-as.numeric(sample[,3])
sample[,4]<-as.numeric(sample[,4])
#sample[,5]<-as.numeric(sample[,5])
str(sample)
#sample$tax = factor(sample$tax, levels=c("Firm-5","Gilliamella","Bifidobacterium","Firm-4","Snodgrassella","Bartonella","Firm5-1","Firm5-2","Firm5-3","Firm5-4","Gilli-1","Gilli-2","Gilli-3","Bifido-1.1","Bifido-1.2","Bifido-1.3","Bifido-1.4","Bifido-2","Firm4-1","Firm4-2","Barto-1","Barto-2","Barto-3"))
sample$tax = factor(sample$tax, levels=c("Barto-3","Barto-2","Barto-1","Firm4-2","Firm4-1","Bifido-2","Bifido-1.4","Bifido-1.3","Bifido-1.2","Bifido-1.1","Gilli-3","Gilli-2","Gilli-1","Firm5-4","Firm5-3","Firm5-2","Firm5-1","Bartonella","Snodgrassella","F4","Bifidobacterium","Gilliamella","F5"))


ggplot(sample,aes(x=Heritability,y=tax))+ #,color=P.value
  geom_errorbarh(aes(xmax=High.95.CI,xmin=Low.95.CI),color="black",height=0,size=0.8)+
  geom_point(aes(x=Heritability,y=tax),size=2)+###点 ,shape=18
  geom_vline(xintercept=0.21,linetype="dashed",size=0.6)+
  scale_x_continuous(breaks=c(0,0.2,0.4,0.6,0.8,1))+
  #scale_y_discrete(labels=c(as.character(sample[,1])))+
  #coord_trans(x="log2")+
  #scale_color_continuous(low="dodgerblue4",high="lightskyblue")+
  #ylab("Gene")+xlab("Hazard ratios")+
  labs(color="P value",title="")+
  theme(panel.grid.major =element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(),axis.line = element_line(colour = "black"))+  
  theme(axis.text=element_text(colour="black",size=12))+  
  theme(legend.text=element_text(size=12))+
  theme(legend.title=element_text(size=12))+
  theme(axis.title=element_text(colour="black",size=12))
