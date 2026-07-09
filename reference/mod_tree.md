# Display a Shiny function module tree

`mod_tree()` statically parses all R source files in a directory,
detects Shiny modules (via calls to
[`shiny::NS()`](https://rdrr.io/pkg/shiny/man/NS.html) or
[`shiny::moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html)),
builds a call graph, and prints a plain-text tree showing the module
hierarchy.

## Usage

``` r
mod_tree(
  path = "R",
  app_fun = "launch",
  ui_fun = "app_ui",
  server_fun = "app_server"
)
```

## Arguments

- path:

  Character scalar; path to the directory containing R source files.
  Defaults to `"R"`.

- app_fun:

  Character scalar; name of the top-level app launch function. Defaults
  to `"launch"`.

- ui_fun:

  Character scalar; name of the UI function. Defaults to `"app_ui"`.

- server_fun:

  Character scalar; name of the server function. Defaults to
  `"app_server"`.

## Value

Invisibly returns the nested tree structure (a list). The tree is
printed to the console as a side effect.

## Examples

``` r
if (FALSE) { # \dontrun{
mod_tree("R")
mod_tree("R", app_fun = "run_app", ui_fun = "ui", server_fun = "server")
} # }
```
