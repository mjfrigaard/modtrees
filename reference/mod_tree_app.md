# Display a module tree from a running Shiny app object

`mod_tree_app()` inspects a `shiny.appobj` at runtime rather than
parsing source files on disk. It extracts the server function via
[`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)'s
internal `serverFuncSource` slot, collects all functions visible in the
server's enclosing environment, identifies Shiny modules with
[`uses_ns()`](https://mjfrigaard.github.io/modtrees/reference/uses_ns.md),
and renders the same plain-text tree as
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md).

## Usage

``` r
mod_tree_app(app, app_fun = "app", ui_fun = NULL, server_fun = NULL)
```

## Arguments

- app:

  A `shiny.appobj`, as returned by
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html).

- app_fun:

  Character scalar; label used for the root node of the tree. Defaults
  to `"app"`. Because the app object does not store the name of the
  launch function, this is a display label only.

- ui_fun:

  Character scalar or `NULL`; name of the UI function. When `NULL` (the
  default), `mod_tree_app()` attempts to recover the UI function
  automatically. Auto-detection succeeds when `ui` was passed to
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html) as
  an **unevaluated** function reference (e.g.
  `shinyApp(ui = app_ui, ...)`). If `ui` was pre-evaluated (e.g.
  `shinyApp(ui = app_ui(), ...)`), supply the function name explicitly
  so the UI branch can be included in the tree.

- server_fun:

  Character scalar or `NULL`; name of the server function. When `NULL`
  (the default), the name is inferred by comparing function bodies
  against those visible in the server's environment.

## Value

Invisibly returns the nested tree structure (a list). The tree is
printed to the console as a side effect.

## See also

[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
for the file-based equivalent.

## Examples

``` r
if (FALSE) { # \dontrun{
app <- shiny::shinyApp(ui = app_ui, server = app_server)
mod_tree_app(app)

# pre-evaluated UI requires explicit ui_fun
app2 <- shiny::shinyApp(ui = app_ui(), server = app_server)
mod_tree_app(app2, ui_fun = "app_ui")

# non-default names
mod_tree_app(app, app_fun = "launch", ui_fun = "movies_ui", server_fun = "movies_server")
} # }
```
