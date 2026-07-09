# Parent module — embeds mod_chart as a child module.
mod_dashboard_ui <- function(id) {
  ns <- NS(id)
  shiny::tagList(
    shiny::h3("Dashboard"),
    shiny::selectInput(
      ns("dataset"),
      "Dataset:",
      choices = c("cars", "pressure", "mtcars")
    ),
    mod_chart_ui(ns("chart"))
  )
}

mod_dashboard_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    dataset <- shiny::reactive({
      get(input$dataset)
    })
    mod_chart_server("chart", data = dataset)
  })
}
