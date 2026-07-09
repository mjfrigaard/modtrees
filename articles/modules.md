# modules

``` r

library(modtrees)
```

This vignette walks through the example Shiny apps using modules.

## Nested modules

When a module calls child modules internally, the tree gains depth.
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
follows the call graph recursively, so nested relationships appear at
the correct level.

``` r

run_demo("03-nested-modules")
```

Here `mod_dashboard` is the parent module. Its UI and server each call
`mod_chart`, making `mod_chart` a grandchild of the app root:

``` r

mod_tree("inst/apps/03-nested-modules/R")
```

``` verbatim
█─launch
├─█─app_ui
│ └─█─mod_dashboard_ui
│   └─█─mod_chart_ui
└─█─app_server
  └─█─mod_dashboard_server
    └─█─mod_chart_server
```

The indentation reflects the true call depth. If `mod_chart` itself
called further modules, they would appear one level deeper.

## No modules

Not every Shiny app uses modules. When
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
finds no functions that call `NS()` or `moduleServer()`, the tree
collapses to just the three top-level functions.

``` r

run_demo("04-no-modules")
```

``` r

mod_tree("inst/apps/04-no-modules/R")
```

``` verbatim
█─launch
├─█─app_ui
└─█─app_server
```

A flat tree like this is a useful signal: either the app genuinely has
no modules, or the module-detection pass missed something. In the latter
case, check that the module functions actually contain `NS()` or
`moduleServer()` calls at the top level of their bodies.

## Many modules

As the number of sibling modules grows, the tree expands horizontally.
This app wires five modules directly into `app_ui` and `app_server`.

``` r

run_demo("05-many-modules")
```

``` r

mod_tree("inst/apps/05-many-modules/R")
```

``` verbatim
█─launch
├─█─app_ui
│ ├─█─mod_header_ui
│ ├─█─mod_filter_ui
│ ├─█─mod_table_ui
│ ├─█─mod_chart_ui
│ └─█─mod_footer_ui
└─█─app_server
  ├─█─mod_header_server
  ├─█─mod_filter_server
  ├─█─mod_table_server
  ├─█─mod_chart_server
  └─█─mod_footer_server
```

The order of children in each branch follows the order in which the
functions are called in the source. `mod_filter` appears second because
it is the second module called in `app_ui()`.
