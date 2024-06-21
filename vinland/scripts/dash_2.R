library(dash)
library(plotly)
#library(dashHtmlComponents)


source("gwas.R")
source("eQTLsummary_per_SNP.R")


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


      

    


# Define the callback to update the graph based on the selected dataset
app$callback(
  output('GWAS-summary-graph', 'figure'),
  list(
    input('GWAS-dataset-dropdown', 'value')
  ),
  function(selectdisease){gwas_plot_maker(selectdisease)}
)

# eQTL plot 
app %>% add_callback(
  output('eQTL-summary-graph','figure'),
  list(
    input('GWAS-summary-graph','hoverData')
  ),
  function(hoverData){
   
    rsid=hoverData$points[[1]]$customdata
    eQTLsumm_plot_maker(rsid)}
)
  
# Markdown 
app %>% add_callback(
  output(id='markdown-block', property = 'children'),
  input('GWAS-summary-graph', 'hoverData'),
  function(hoverData){
    rsid=hoverData$points[[1]]$customdata
    markdown_text <- paste('#### Link Outs\n
                 \n GGV link: (https://popgen.uchicago.edu/ggv/?data=%221000genomes%22&rsid=',
                  rsid,
                  ')\n\n UCSC Genome Browser link: (http://genome.ucsc.edu/cgi-bin/hgTracks?db=hg38&knownGene=pack&position=',
                  rsid,')',
                  sep="")
    return(markdown_text)
  }
)


# GGV embed

app %>% add_callback(
  output(id='GGV-plot', property = 'src'),
  input('GWAS-summary-graph', 'hoverData'),
  function(hoverData){
    rsid=hoverData$points[[1]]$customdata
    url <- paste('https://popgen.uchicago.edu/ggv/?data=%221000genomes%22&rsid=',
                 rsid,
                 sep="")
    #return(html$iframe(src = url, style = list(height = 400, width = 100)))
    return(url)
        #return(html$iframe('https://www.example.com'))
    #return(html$iframe(src = 'http://www.example.com', style = list(height = 400, width = 100)))
  }
)




# Run the app
port = 8000
print(paste0('Dash app running on http://127.0.0.1:', port, '/'))
app %>% run_app(port = port)