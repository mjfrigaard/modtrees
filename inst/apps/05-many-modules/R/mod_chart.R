mod_chart_ui <- function(id) {
  ns <- NS(id)
  shiny::plotOutput(ns("plot"))
}

mod_chart_server <- function(id, filter) {
  moduleServer(id, function(input, output, session) {
    output$plot <- shiny::renderPlot({
      vals  <- filter()
      d     <- iris[iris$Species == vals$species &
                      iris$Sepal.Length >= vals$sepal_len, ]
      plot(d$Sepal.Length, d$Petal.Length,
           xlab = "Sepal Length", ylab = "Petal Length",
           pch = 19, col = "steelblue")
    })
  })
}
