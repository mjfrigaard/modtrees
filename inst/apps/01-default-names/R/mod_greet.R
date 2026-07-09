mod_greet_ui <- function(id) {
  ns <- NS(id)
  shiny::tagList(
    shiny::textInput(ns("name"), "Your name:", placeholder = "e.g. Ada"),
    shiny::textOutput(ns("greeting"))
  )
}

mod_greet_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$greeting <- shiny::renderText({
      if (nzchar(input$name)) {
        paste0("Hello, ", input$name, "!")
      } else {
        "Enter your name above."
      }
    })
  })
}
