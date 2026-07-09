# mod_tree("inst/apps/02-custom-names/R",
#          app_fun = "run_app", ui_fun = "ui", server_fun = "server")
#
# Expected tree:
#   █─run_app
#   └─█─ui
#     └─█─mod_counter_ui
#   └─█─server
#     └─█─mod_counter_server

run_app <- function(options = list()) {
  shiny::shinyApp(
    ui     = ui(),
    server = server,
    options = options
  )
}
