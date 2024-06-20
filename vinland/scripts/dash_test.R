app <- Dash$new()



# Define the layout of the app


app %>% set_layout(  div(
  dccDropdown(
    id = "Disease",
    options = option_indicator,
    value = "Fertility rate, total (births per woman)"
  ),
  style = list(width = "49%", display = "inline-block")
), div(
  list(
    h1("Dash Example"),
    dccGraph(id = "example-graph", figure = gwas_plot_maker("UC"))
  )
))


  



app$layout(
  
  
)

# Run the app
app$run_server()
