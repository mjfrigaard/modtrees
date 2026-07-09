# mod_tree("inst/apps/01-default-names/R")
#
# Expected tree:
#   █─launch
#   └─█─app_ui
#     └─█─mod_greet_ui
#   └─█─app_server
#     └─█─mod_greet_server

launch <- function(options = list()) {
  shiny::shinyApp(
    ui     = app_ui(),
    server = app_server,
    options = options
  )
}
