# mod_tree("inst/apps/05-many-modules/R")
#
# Expected tree (wide — five sibling modules):
#   █─launch
#   └─█─app_ui
#     ├─█─mod_header_ui
#     ├─█─mod_filter_ui
#     ├─█─mod_table_ui
#     ├─█─mod_chart_ui
#     └─█─mod_footer_ui
#   └─█─app_server
#     ├─█─mod_header_server
#     ├─█─mod_filter_server
#     ├─█─mod_table_server
#     ├─█─mod_chart_server
#     └─█─mod_footer_server

launch <- function(options = list()) {
  shiny::shinyApp(
    ui     = app_ui(),
    server = app_server,
    options = options
  )
}
