#' Launch a demo Shiny app
#'
#' Launches one of the demo Shiny applications bundled with `modtrees`.
#' When called without arguments it runs the original Movies Review app
#' (`inst/app/`). Pass a folder name from `inst/apps/` to launch one of
#' the targeted `mod_tree()` test apps.
#'
#' @param app Character scalar; name of an app folder inside `inst/apps/`,
#'   e.g. `"01-default-names"`. Pass `NULL` (the default) to launch the
#'   original Movies Review demo in `inst/app/`.
#' @param options A named list of options passed to [shiny::shinyAppDir()],
#'   e.g. `list(port = 8080)`.
#'
#' @return A Shiny application object (invisibly).
#'
#' @examples
#' if (interactive()) {
#'   # original demo
#'   run_demo()
#'
#'   # targeted test apps
#'   run_demo("01-default-names")
#'   run_demo("02-custom-names")
#'   run_demo("03-nested-modules")
#'   run_demo("04-no-modules")
#'   run_demo("05-many-modules")
#'   run_demo("06-realistic-with-helpers")
#' }
#'
#' @export
run_demo <- function(app = NULL, options = list()) {

  if (is.null(app)) {
    app_dir <- system.file("app", package = "modtrees")
    if (app_dir == "") {
      app_dir <- normalizePath("inst/app", mustWork = TRUE)
    }
    return(shiny::shinyAppDir(appDir = app_dir, options = options))
  }

  # resolve from inst/apps/<app>/
  app_dir <- system.file("apps", app, package = "modtrees")

  if (app_dir == "") {
    # development fallback
    app_dir <- normalizePath(file.path("inst/apps", app), mustWork = FALSE)
  }

  if (!dir.exists(app_dir)) {
    available <- list.dirs(
      system.file("apps", package = "modtrees"),
      full.names = FALSE, recursive = FALSE
    )
    if (length(available) == 0L) {
      available <- list.dirs(
        normalizePath("inst/apps", mustWork = FALSE),
        full.names = FALSE, recursive = FALSE
      )
    }
    stop(
      sprintf(
        "App '%s' not found in inst/apps/. Available apps:\n  %s",
        app, paste(available, collapse = "\n  ")
      ),
      call. = FALSE
    )
  }

  shiny::shinyAppDir(appDir = app_dir, options = options)
}
