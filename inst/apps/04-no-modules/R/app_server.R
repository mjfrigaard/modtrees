app_server <- function(input, output, session) {
  output$scatter <- shiny::renderPlot({
    x <- rnorm(input$n)
    y <- rnorm(input$n)
    plot(x, y, pch = 19, col = "steelblue")
  })
}
