library(plotly)

sadness_maker<-function(){
# Create data for the face outline (a circle)
theta <- seq(0, 2 * pi, length.out = 100)
face <- data.frame(
  x = cos(theta),
  y = sin(theta)
)

# Create data for the left eye
left_eye <- data.frame(
  x = -0.3,
  y = 0.5
)

# Create data for the right eye
right_eye <- data.frame(
  x = 0.3,
  y = 0.5
)

# Create data for the sad mouth (a downward quadratic curve)
mouth_x <- seq(-0.4, 0.4, length.out = 100)
mouth <- data.frame(
  x = mouth_x,
  y = -0.5 - 0.2 * (mouth_x)^2
)

# Plot the sad face using plotly
fig <- plot_ly() %>%
  add_trace(data = face, x = ~x, y = ~y, type = 'scatter', mode = 'lines', name = 'Face') %>%
  add_trace(data = left_eye, x = ~x, y = ~y, type = 'scatter', mode = 'markers', name = 'Left Eye') %>%
  add_trace(data = right_eye, x = ~x, y = ~y, type = 'scatter', mode = 'markers', name = 'Right Eye') %>%
  add_trace(data = mouth, x = ~x, y = ~y, type = 'scatter', mode = 'lines', name = 'Mouth')

# Customize the layout
fig <- fig %>%
  layout(title = 'Sad Face',
         xaxis = list(title = '', showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(title = '', showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         showlegend = FALSE)

return(fig)
}
# Display the plot

