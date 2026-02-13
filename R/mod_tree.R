#' Display a Shiny module tree
#'
#' Statically parses all R source files in a directory, detects Shiny modules
#' (via calls to [shiny::NS()] or [shiny::moduleServer()]), builds a call
#' graph, and prints a plain-text tree showing the module hierarchy.
#'
#' @param path Character scalar; path to the directory containing R source
#'   files. Defaults to `"R"`.
#' @param app_fun Character scalar; name of the top-level app launch function.
#'   Defaults to `"launch"`.
#' @param ui_fun Character scalar; name of the UI function.
#'   Defaults to `"app_ui"`.
#' @param server_fun Character scalar; name of the server function.
#'   Defaults to `"app_server"`.
#'
#' @return Invisibly returns the nested tree structure (a list). The tree
#'   is printed to the console as a side effect.
#'
#' @examples
#' \dontrun{
#' mod_tree("R")
#' mod_tree("R", app_fun = "run_app", ui_fun = "ui", server_fun = "server")
#' }
#'
#' @export
mod_tree <- function(path = "R",
                     app_fun = "launch",
                     ui_fun = "app_ui",
                     server_fun = "app_server") {

  # 1. Parse all .R files and extract function definitions
  r_files <- list.files(path, pattern = "\\.[Rr]$", full.names = TRUE)

  func_defs <- list()
  for (f in r_files) {
    exprs <- tryCatch(parse(f), error = function(e) NULL)
    if (is.null(exprs)) next
    for (expr in exprs) {
      def <- extract_func_def(expr)
      if (!is.null(def)) {
        func_defs[[def$name]] <- def$body
      }
    }
  }

  known_names <- names(func_defs)

  # 2. Detect which functions are modules (call NS() or moduleServer())
  is_module <- vapply(func_defs, function(body) {
    uses_ns(body)
  }, logical(1))

  module_names <- names(which(is_module))
  important <- c(app_fun, ui_fun, server_fun)
  target_names <- union(important, module_names)

  # 3. Build call graph (only edges to target functions)
  call_graph <- lapply(func_defs, function(body) {
    calls <- find_calls(body, known_names)
    intersect(calls, target_names)
  })

  # 4. Build tree via DFS from app_fun
  tree <- build_tree(app_fun, call_graph, visited = character(0))

  # 5. Render
  lines <- render_tree(tree, prefix = "", is_last = TRUE, is_root = TRUE)
  cat(paste(lines, collapse = "\n"), "\n")

  invisible(tree)
}
