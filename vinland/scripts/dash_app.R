library(dash)
app <- dash_app()

app %>% set_layout(
  # div(
  #   dccDropdown(
  #     id = 'Disease',
  #     options = list(
  #       list(label = 'UC', value = 'UC'),
  #       list(label = 'AS', value = 'AS')),
  #     value = 'UC'
  #     ),
  #   style = list(width = '49%', float = 'right', display = 'inline-block')
  #   ),
  div(
    dccGraph(id='Manhattan'),
    style = list(width = '49%', float = 'right', display = 'inline-block')
  ),
)
  
  app %>% add_callback(
    output('Manhattan', 'figure'),
#    list(
 #     input('Disease', 'value'),
  #  ),
    function(disease="UC"){
      gwas_plot_maker(disease)
    }
  )
  
   port = 8006
   print(paste0('Dash app running on http://127.0.0.1:', port, '/'))
   app %>% run_app(port = port)
  
# list(
# list(label = 'UC', value = 'UC'),
# list(label = 'AS', value = 'AS'))
