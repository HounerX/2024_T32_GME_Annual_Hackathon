library(dash)
library(plotly)

source("gwas.R")
source("eQTLsummary_per_SNP.R")


# Initialize the Dash app
app <- Dash$new()

# Define the layout of the app
app$layout(
  div(
    list(
      dccDropdown(
        id = 'GWAS-dataset-dropdown',
        options = list(
          list(label = 'UC', value = 'UC'),
          list(label = 'CD', value = 'CD')
        ),
        value = 'UC'
      ),
      dccGraph(id = 'GWAS-summary-graph'),
      dccGraph(id = 'eQTL-summary-graph')
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

app %>% add_callback(
  output('eQTL-summary-graph','figure'),
  list(
    input('GWAS-summary-graph','hoverData')
  ),
  function(hoverData){
    print(hoverData$points[[1]]$customdata)
    rsid=hoverData$points[[1]]$customdata
    eQTLsumm_plot_maker(rsid)}
)
  


# Run the app
port = 8000
print(paste0('Dash app running on http://127.0.0.1:', port, '/'))
app %>% run_app(port = port)