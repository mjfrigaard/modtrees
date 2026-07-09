ui <- function() {
  shiny::fluidPage(
    shiny::titlePanel("Counter App"),
    mod_counter_ui("counter")
  )
}
