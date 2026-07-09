app_ui <- function() {
  shiny::fluidPage(
    shiny::titlePanel("Dashboard App"),
    mod_dashboard_ui("dash")
  )
}
