#' Launch the demo Shiny app
#'
#' Launches the demo Movies Review Shiny application bundled with `modtrees`
#' in `inst/app/`. This is a self-contained app that demonstrates Shiny module
#' structure for use with [mod_tree()].
#'
#' @param options A named list of options passed to [shiny::shinyAppDir()],
#'   e.g. `list(port = 8080)`.
#'
#' @return A Shiny application object (invisibly).
#'
#' @examples
#' if (interactive()) {
#'   run_demo()
#' }
#'
#' @export
run_demo <- function(options = list()) {
  app_dir <- system.file("app", package = "modtrees")
  if (app_dir == "") {
    app_dir <- normalizePath("inst/app", mustWork = TRUE)
  }
  shiny::shinyAppDir(appDir = app_dir, options = options)
}
