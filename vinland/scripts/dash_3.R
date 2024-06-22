
library(dash)
library(plotly)
#library(dashHtmlComponents)


source("gwas.R")
source("eQTLsummary_per_SNP.R")
source("LD_matrix_maker.R")

ld_mat = readRDS("precal_ldmat.rds")

# Initialize the Dash app
app <- Dash$new()

# Define the layout of the app
app$layout(
  div(
    list(
      div(
        dccDropdown(
          id = 'GWAS-dataset-dropdown',
          options = list(
            list(label = 'UC', value = 'UC'),
            list(label = 'CD', value = 'CD')
          ),
          value = 'UC'
        ),
        dccGraph(id = 'GWAS-summary-graph',
                 style = list(width = '80%', height='200px',display = 'inline-block')
        ),
        dccGraph(id = 'eQTL-summary-graph',
                 style = list(width = '20%', height='200px',display = 'inline-block')
        ),
        div(
          dccGraph(id = 'LD-plot'),
          style = list(width = '49%', height='25%',display = 'inline-block')
        )
      ),
      div(
        dccMarkdown(id = 'markdown-block',
                    children= "
          ```Hover over a SNP in the GWAS plot 
          ```",
                    style = list(width = '100%',display = 'inline-block')
        )
      ),
      #   div(
      
      #   style = list(width = '20%', height='2000px',display = 'inline-block')
      #  )
      #,
      # dccMarkdown('
      #   #### Dash and Markdown
      #   Dash supports [Markdown](http://commonmark.org/help).
      #   Markdown is a simple way to write and format text.
      #   It includes a syntax for things like **bold text** and *italics*,
      #   [links](http://commonmark.org/help), inline `code` snippets, lists,
      #   quotes, and more.'),
      div(
        html$iframe(
          src = 'http://popgen.uchicago.edu/ggv', 
          #style = list(height = 400, width = 100),
          id = 'GGV-plot',
          style = list(width = '60%', height='600px',display = 'inline-block')
          #   style = list(width = '100px', display = 'inline-block')
        )
        #style = list(width = '100%', display = 'inline-block')
      )
    )
  )
)





cnt<-0

# Define the callback to update the graph based on the selected dataset
app$callback(
  output('GWAS-summary-graph', 'figure'),
  list(
    input('GWAS-dataset-dropdown', 'value'), 
    input('LD-plot','clickData')
  ),
  function(selectdisease, clickData){
    if(cnt==0){
      gwas_plot = gwas_plot_maker(selectdisease)
      cnt=cnt+1
    }
    if (!is.null(clickData[[1]])){
      print("Yaya Click Data")
      rsid1 = clickData$points[[1]]$x 
      rsid2 = clickData$points[[1]]$y
      gwas_rsid = gwas_plot$x$data[[1]]$customdata
      gwas_index = gwas_plot$x$data[[1]]$x
      gwas_y = gwas_plot$x$data[[1]]$y
      x1 = gwas_index[gwas_rsid == rsid1]
      x2 = gwas_index[gwas_rsid == rsid2]
      xs = c(x1, x2)
      y1 = gwas_y[gwas_rsid == rsid1]
      y2 = gwas_y[gwas_rsid == rsid2]
      ys = c(y1, y2)
      print(x1)
      print(x2)
      print(xs)
      print(ys)
      print(y1)
      print(y2)

      gwas_plot = gwas_plot %>% add_trace(x = xs, 
                                            y= ys, 
                                            color = 'green',
                                            mode="marker", 
                                            marker = list(size = 20) )

    }
    return(gwas_plot)

  }
)

# eQTL plot 
app %>% add_callback(
  output('eQTL-summary-graph','figure'),
  list(
    input('GWAS-summary-graph','clickData')
  ),
  function(clickData){
    
    rsid=clickData$points[[1]]$customdata
    eQTLsumm_plot_maker(rsid)}
)

# Markdown
app %>% add_callback(
  output(id='markdown-block', property = 'children'),
  input('GWAS-summary-graph', 'clickData'),
  function(clickData){
    rsid=clickData$points[[1]]$customdata
    markdown_text <- paste('#### Link Outs\n
                  \n GGV link: (https://popgen.uchicago.edu/ggv/?data=%221000genomes%22&rsid=',
                           rsid,
                           ')\n\n UCSC Genome Browser link: (http://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&knownGene=pack&position=',
                           rsid,')',
                           sep="")
    return(markdown_text)
  }
)

#app %>% add_callback(
#  output(id='GWAS-summary-graph', 'figure'),
  # list(
  #   #input('GWAS-summary-graph', 'figure'),
  #   input('LD-plot','clickData')
  # ),
  # function(clickData){
  #   gwas_plot_maker("UC")
    # rsid1 = clickData$points[[1]]$x 
    # rsid2 = clickData$points[[1]]$y
    # gwas_rsid = figure$x$data[[1]]$customdata
    # gwas_index = figure$x$data[[1]]$x
    # gwas_y = figure$x$data[[1]]$y
    # x1 = gwas_index[gwas_rsid == rsid1]
    # x2 = gwas_index[gwas_rsid == rsid2]
    # xs = c(x1, x2)
    # y1 = gwas_y[gwas_rsid == rsid1]
    # y2 = gwas_y[gwas_rsid == rsid1]
    # ys = c(y1, y2)
    # figure = figure %>% add_trace(x = xs, y= ys, color = 'green', size = 5)
#  }
#)

#LD plot

app %>% add_callback(
  output('LD-plot', 'figure'),
  list(
    input('GWAS-summary-graph', 'clickData')
  ),
  function(clickData) {
    rsid = clickData$points[[1]]$customdata
    ld_plot_maker(rsid,ld_mat)
  }
  
)


# GGV embed

app %>% add_callback(
  output(id='GGV-plot', property = 'src'),
  input('GWAS-summary-graph', 'clickData'),
  function(clickData){
    rsid=clickData$points[[1]]$customdata
    url <- paste('https://popgen.uchicago.edu/ggv/?data=%221000genomes%22&rsid=',
                 rsid,
                 sep="")
    #return(html$iframe(src = url, style = list(height = 400, width = 100)))
    return(url)
    #      return(html$iframe('https://www.example.com'))
    # return(html$iframe(src = 'http://www.example.com', style = list(height = 400, width = 100)))
  }
)



port = 8200
print(paste0('Dash app running on http://127.0.0.1:', port, '/'))
app %>% run_app(port = port)