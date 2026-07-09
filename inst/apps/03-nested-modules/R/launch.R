# mod_tree("inst/apps/03-nested-modules/R")
#
# Expected tree:
#   █─launch
#   └─█─app_ui
#     └─█─mod_dashboard_ui
#       └─█─mod_chart_ui
#   └─█─app_server
#     └─█─mod_dashboard_server
#       └─█─mod_chart_server

launch <- function(options = list()) {
  shiny::shinyApp(
    ui     = app_ui(),
    server = app_server,
    options = options
  )
}
