library(reshape2)

f <- function(x) {
  if(is.list(x)) lapply(x, f)
  else ifelse(length(x) == 0, 0, x)
}
source("sad_face_maker.R")

ld_plot_maker <- function(snp_to_query,ld_mat, window_size = 1000){
  #ld_mat=read.table("../data/ld_matrix.ld",header = TRUE,stringsAsFactors = FALSE)
  
  bim_file=read.table("../data/yazar_final.bim",stringsAsFactors = FALSE)
  #snp_to_query="rs9268832"
  
  chr_to_query=bim_file[bim_file$V2==snp_to_query,1]
  pos_to_query=bim_file[bim_file$V2==snp_to_query,4]
  
#  ld_mat=ld_mat[ld_mat$CHR_A==chr_to_query,]
  
  the_condition=bim_file$V1==chr_to_query & bim_file$V4>(pos_to_query-window_size) &  bim_file$V4<(window_size+pos_to_query)
  
  bim_file_in_window=bim_file[the_condition ,]
 
  ld_mat=ld_mat[ld_mat$SNP_A %in% bim_file_in_window[,2],] 
  
  all_snps_to_ld_mat=bim_file_in_window$V2
  
  
  
  if(NROW(all_snps_to_ld_mat)==0){
    
    return(sadness_maker())
    
  }
  
  
  
  
  the_ld_matrix_to_plot=matrix(NA,NROW(all_snps_to_ld_mat),NROW(all_snps_to_ld_mat))
  
  
  rownames(the_ld_matrix_to_plot)=all_snps_to_ld_mat
  colnames(the_ld_matrix_to_plot)=all_snps_to_ld_mat
  
  
  
  
  
  
  for(snp1_i in 1:NROW(all_snps_to_ld_mat)){
    
    for(snp2_i in snp1_i:NROW(all_snps_to_ld_mat)){
      
      snp1=all_snps_to_ld_mat[snp1_i]
      snp2=all_snps_to_ld_mat[snp2_i]
      
      
      if(snp1==snp2){
        r2=1
      }else{
        
        r2_1=as.numeric(ld_mat[(ld_mat$SNP_A==snp1) & (ld_mat$SNP_B==snp2),7])
        
        
        
        r2_2=as.numeric(ld_mat[(ld_mat$SNP_B==snp1) & (ld_mat$SNP_A==snp2),7])
        
        r2_1=f(r2_1)
        r2_2=f(r2_2)
        
        r2=r2_1+r2_2
      }
      
      the_ld_matrix_to_plot[snp1,snp2]=r2
      the_ld_matrix_to_plot[snp2,snp1]=r2

    }

  }
  
  
  
  long_df <- melt(the_ld_matrix_to_plot)
  
  
  
  fig_ld<-plot_ly(data = long_df,x=~Var1,
                  y=~Var2,
                  z=~value,
                  hoverinfo = 'text',
                  text = ~paste('SNP1:', Var1,
                                '<br>SNP2:', Var2,
                                '<br>r2:', value),
                  type="heatmap"
  )
  
  
  return(fig_ld)
 
}

