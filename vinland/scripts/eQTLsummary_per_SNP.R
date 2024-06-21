library(plotly)
library(ggplot2)
library(dplyr)
library(jsonlite)
library(htmlwidgets)

library(gapminder)
library(quantmod)


#Cell type,Gene ID,Gene Ensembl ID,SNP,Chromosome,Position,SNP assessed allele,eSNP rank,rho correlation coefficient,S-statistics,pvalue,qvalue,FDR
#B IN,RP11-298J20.3,ENSG00000226899,rs4962711,10,126644482,C,eSNP1,-0.473,232418781.992,8.653e-56,5.108e-50,2.164e-05
#B IN,PPA1,ENSG00000180817,rs12355080,10,71963608,A,eSNP1,0.428,90338125.825,6.308e-45,1.646e-40,2.164e-05
#B IN,GDI2

# awk 'BEGIN{FS=","}{snpcnt[$4]++}END{for(i in snpcnt) if(snpcnt[i]>1) print i, snpcnt[i]}' cis_eqtls_S10.csv

# rs5760147 15
# rs114179634 2
# rs9298467 4
# rs12151742 2
# rs5760147 15
# rs11935857 2

eQTLsumm_plot_maker <- function(rsid="rs5760147"){


  df <- read.csv("../data/cis_eqtls_S10.csv",header=TRUE)
  
  
  df_filtered<-df[df$SNP==rsid,]
  df_filtered$Gene.ID<-as.factor(df_filtered$Gene.ID)
#  if(dim(df_filtered,1)==0)  
  
  
  fig <- plot_ly(data = df_filtered, 
                      x = ~Gene.ID, 
                      y = ~-log10(FDR), 
                      # size = ~pop, #Specifiying that the point size be based on the population size causes an error for me for some odd reason, maybe your results will vary if you want to uncomment this and try it out
                      color = ~Cell.type,
                      #text = ~country, 
                      # frame = ~year, 
                      type = 'bar', 
                      #mode = 'markers',
                      #marker = list(sizemode = 'diameter', sizeref = 2e5, sizemin = 1),
                      showlegend=FALSE,
                      hoverinfo = 'text',
                      text = ~paste('ID:', Gene.ID,
                                    '<br>Cell type:', Cell.type) 
                                    
  ) 
  fig
  return(fig)
}

# rs5760147 15
# rs114179634 2
# rs9298467 4
# rs12151742 2
# rs5760147 15
# rs11935857 2
#eQTLsumm_plot_maker("rs11935857")

