#' Display a module tree from a running Shiny app object
#'
#' `mod_tree_app()` inspects a `shiny.appobj` at runtime rather than parsing
#' source files on disk. It extracts the server function via
#' [shiny::shinyApp()]'s internal `serverFuncSource` slot, collects all
#' functions visible in the server's enclosing environment, identifies Shiny
#' modules with [uses_ns()], and renders the same plain-text tree as
#' [mod_tree()].
#'
#' @param app A `shiny.appobj`, as returned by [shiny::shinyApp()].
#' @param app_fun Character scalar; label used for the root node of the tree.
#'   Defaults to `"app"`. Because the app object does not store the name of
#'   the launch function, this is a display label only.
#' @param ui_fun Character scalar or `NULL`; name of the UI function.
#'   When `NULL` (the default), `mod_tree_app()` attempts to recover the UI
#'   function automatically. Auto-detection succeeds when `ui` was passed to
#'   [shiny::shinyApp()] as an **unevaluated** function reference
#'   (e.g. `shinyApp(ui = app_ui, ...)`). If `ui` was pre-evaluated
#'   (e.g. `shinyApp(ui = app_ui(), ...)`), supply the function name
#'   explicitly so the UI branch can be included in the tree.
#' @param server_fun Character scalar or `NULL`; name of the server function.
#'   When `NULL` (the default), the name is inferred by comparing function
#'   bodies against those visible in the server's environment.
#'
#' @return Invisibly returns the nested tree structure (a list). The tree is
#'   printed to the console as a side effect.
#'
#' @examples
#' \dontrun{
#' app <- shiny::shinyApp(ui = app_ui, server = app_server)
#' mod_tree_app(app)
#'
#' # pre-evaluated UI requires explicit ui_fun
#' app2 <- shiny::shinyApp(ui = app_ui(), server = app_server)
#' mod_tree_app(app2, ui_fun = "app_ui")
#'
#' # non-default names
#' mod_tree_app(app, app_fun = "launch", ui_fun = "movies_ui", server_fun = "movies_server")
#' }
#'
#' @seealso [mod_tree()] for the file-based equivalent.
#'
#' @export
mod_tree_app <- function(app,
                          app_fun    = "app",
                          ui_fun     = NULL,
                          server_fun = NULL) {

  if (!inherits(app, "shiny.appobj")) {
    stop(
      "`app` must be a shiny.appobj. ",
      "Create one with shiny::shinyApp() or shiny::shinyAppDir().",
      call. = FALSE
    )
  }

  # --- server ---
  server_fn <- app$serverFuncSource()
  env       <- environment(server_fn)

  # collect all functions from the server's enclosing environment chain;
  # traverse parents until globalenv or a named package namespace is reached
  # so that helpers defined in parent scopes (e.g. test files) are included
  known_fns <- list()
  e <- env
  while (!identical(e, emptyenv())) {
    local_fns <- Filter(is.function, as.list(e))
    new_names <- setdiff(names(local_fns), names(known_fns))
    known_fns <- c(known_fns, local_fns[new_names])
    if (identical(e, globalenv()) || identical(e, baseenv())) break
    env_nm <- environmentName(e)
    if (nchar(env_nm) > 0 && env_nm %in% loadedNamespaces())  break
    e <- parent.env(e)
  }
  known_names <- names(known_fns)

  # --- detect modules ---
  is_module    <- vapply(known_fns, function(f) uses_ns(body(f)), logical(1))
  module_names <- names(which(is_module))

  # --- resolve server name ---
  s_name <- server_fun
  if (is.null(s_name)) {
    s_name <- .find_fn_name(server_fn, known_fns)
  }
  if (is.null(s_name)) s_name <- "server"

  # --- resolve UI ---
  ui_stored <- tryCatch(
    environment(app$httpHandler)$ui,
    error = function(e) NULL
  )

  if (!is.null(ui_fun)) {
    # user supplied a name; look it up in the environment
    ui_fn <- tryCatch(
      get(ui_fun, envir = env, inherits = TRUE),
      error = function(e) NULL
    )
    ui_name <- ui_fun
    # add to known_fns if missing (e.g. it lives in a parent env)
    if (!is.null(ui_fn) && !ui_name %in% known_names) {
      known_fns[[ui_name]]  <- ui_fn
      known_names           <- c(known_names, ui_name)
    }
  } else if (is.function(ui_stored)) {
    ui_fn   <- ui_stored
    ui_name <- .find_fn_name(ui_fn, known_fns)
    if (is.null(ui_name)) {
      ui_name                <- "ui"
      known_fns[["ui"]]      <- ui_fn
      known_names            <- c(known_names, "ui")
    }
  } else {
    ui_fn   <- NULL
    ui_name <- NULL
  }

  # --- build target set ---
  important    <- Filter(Negate(is.null), c(app_fun, ui_name, s_name))
  target_names <- union(important, module_names)

  # --- call graph ---
  call_graph <- list()

  # root node: children are ui and server (in that order, matching shinyApp())
  call_graph[[app_fun]] <- Filter(Negate(is.null), c(ui_name, s_name))

  for (nm in setdiff(target_names, app_fun)) {
    fn <- known_fns[[nm]]
    if (is.null(fn)) next
    calls              <- find_calls(body(fn), known_names)
    call_graph[[nm]]   <- intersect(calls, target_names)
  }

  # --- render ---
  tree  <- build_tree(app_fun, call_graph)
  lines <- render_tree(tree, prefix = "", is_last = TRUE, is_root = TRUE)
  cat(paste(lines, collapse = "\n"), "\n")
  invisible(tree)
}

# Match a function to its name in a named list by comparing bodies.
.find_fn_name <- function(fn, known_fns) {
  for (nm in names(known_fns)) {
    if (identical(body(fn), body(known_fns[[nm]]))) return(nm)
  }
  NULL
}
