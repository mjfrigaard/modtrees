mod_header_ui <- function(id) {
  ns <- NS(id)
  shiny::tagList(
    shiny::h1("Data Explorer"),
    shiny::textOutput(ns("subtitle"))
  )
}

mod_header_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$subtitle <- shiny::renderText("Explore your data interactively.")
  })
}
