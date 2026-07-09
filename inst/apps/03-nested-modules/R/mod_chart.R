# Child module — leaf node in the tree.
mod_chart_ui <- function(id) {
  ns <- NS(id)
  shiny::plotOutput(ns("plot"))
}

mod_chart_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    output$plot <- shiny::renderPlot({
      plot(data())
    })
  })
}
