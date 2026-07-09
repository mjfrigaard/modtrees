# Launch the demo Shiny app

Launches the demo Movies Review Shiny application bundled with
`modtrees` in `inst/app/`. This is a self-contained app that
demonstrates Shiny module structure for use with
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md).

## Usage

``` r
run_demo(options = list())
```

## Arguments

- options:

  A named list of options passed to
  [`shiny::shinyAppDir()`](https://rdrr.io/pkg/shiny/man/shinyApp.html),
  e.g. `list(port = 8080)`.

## Value

A Shiny application object (invisibly).

## Examples

``` r
if (interactive()) {
  run_demo()
}
```
