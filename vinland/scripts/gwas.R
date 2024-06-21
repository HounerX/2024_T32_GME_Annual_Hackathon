library(plotly)
library(ggplot2)
library(dplyr)
library(jsonlite)
library(htmlwidgets)

library(gapminder)
library(quantmod)


gwas_plot_maker<-function(disease_name="UC",display_thres_cutoff=0.01){
  
  gwas_file=read.table("../config/gwas_filetable.txt",header = TRUE)
  
  eQTL_file=read.csv("../data/cis_eqtls_S10.csv",header = TRUE)
  
  
  
  
  filename=gwas_file[gwas_file$disease==disease_name,"path"]
  
  
  
  
  
  
  df <- read.table(filename,header = TRUE)
  
  df$base_pair_location<-as.numeric(df$base_pair_location)
  
  df$chromosome<-as.numeric(df$chromosome)
  
  theorder<-order(df$chromosome,df$base_pair_location)
  df=df[theorder,]

  df_filtered<-df[df$p_value<display_thres_cutoff,]
  df_filtered$index=c(1:NROW(df_filtered))
  
  df_filtered$is_cis_eQTL <- as.numeric(df_filtered$variant_id %in% eQTL_file$SNP)  
  
  fig_gwas <- plot_ly(data = df_filtered, 
                 x = ~index, 
                 y = ~-log10(p_value), 
                 #= ~is_cis_eQTL, #Specifiying that the point size be based on the population size causes an error for me for some odd reason, maybe your results will vary if you want to uncomment this and try it out
                 color = ~(chromosome%%2), 
                 #text = ~country, 
                # frame = ~year, 
                 type = 'scatter', 
                 mode = 'markers',
                 marker = list(size=2.5), #list(sizemode = 'diameter', sizeref = 10, sizemin = 1),
                 hoverinfo = 'text',
                 text = ~paste('ID:', variant_id, 
                                '<br>chr:', chromosome, 
                                '<br>bp:', base_pair_location),
                customdata = ~variant_id
                ) %>% hide_colorbar() 
  fig_gwas = fig_gwas %>% add_trace(
    data = df_filtered[df_filtered$is_cis_eQTL==1,],
    x = ~index,
    y = ~-log10(p_value),
    # size = ~pop, #Specifiying that the point size be based on the population size causes an error for me for some odd reason, maybe your results will vary if you want to uncomment this and try it out
    color = 'red',
    #text = ~country,
    # frame = ~year,
    type = 'scatter',
    mode = 'markers',
    marker = list(size=5),
    #showlegend=FALSE,
    hoverinfo = 'text',
    text = ~paste('ID:', variant_id,
                  '<br>chr:', chromosome,
                  '<br>bp:', base_pair_location),
    customdata = ~variant_id
  )
  return(fig_gwas)

}


gwas_plot_maker()