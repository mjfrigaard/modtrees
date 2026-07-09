# Launch a demo Shiny app

Launches one of the demo Shiny applications bundled with `modtrees`.
When called without arguments it runs the original Movies Review app
(`inst/app/`). Pass a folder name from `inst/apps/` to launch one of the
targeted
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
test apps.

## Usage

``` r
run_demo(app = NULL, options = list())
```

## Arguments

- app:

  Character scalar; name of an app folder inside `inst/apps/`, e.g.
  `"01-default-names"`. Pass `NULL` (the default) to launch the original
  Movies Review demo in `inst/app/`.

- options:

  A named list of options passed to
  [`shiny::shinyAppDir()`](https://rdrr.io/pkg/shiny/man/shinyApp.html),
  e.g. `list(port = 8080)`.

## Value

A Shiny application object (invisibly).

## Examples

``` r
if (interactive()) {
  # original demo
  run_demo()

  # targeted test apps
  run_demo("01-default-names")
  run_demo("02-custom-names")
  run_demo("03-nested-modules")
  run_demo("04-no-modules")
  run_demo("05-many-modules")
  run_demo("06-realistic-with-helpers")
}
```
