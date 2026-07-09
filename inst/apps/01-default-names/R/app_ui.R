app_ui <- function() {
  shiny::fluidPage(
    shiny::titlePanel("Greeter App"),
    mod_greet_ui("greet")
  )
}
