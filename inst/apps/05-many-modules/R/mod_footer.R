mod_footer_ui <- function(id) {
  ns <- NS(id)
  shiny::tagList(
    shiny::hr(),
    shiny::textOutput(ns("info"))
  )
}

mod_footer_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$info <- shiny::renderText({
      paste("Session started:", Sys.time())
    })
  })
}
