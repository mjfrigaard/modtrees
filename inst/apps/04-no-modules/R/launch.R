# mod_tree("inst/apps/04-no-modules/R")
#
# Expected tree (flat — no modules detected):
#   █─launch
#   └─█─app_ui
#   └─█─app_server

launch <- function(options = list()) {
  shiny::shinyApp(
    ui     = app_ui(),
    server = app_server,
    options = options
  )
}
