# Realistic App

``` r

library(modtrees)
```

This vignette uses a realistic example of an R application with
additional utility functions.

## Realistic app with helper functions

The previous examples are deliberately minimal. Production apps include
utilities alongside modules: logging helpers, data loaders, plot
functions, and other non-module code. This app has all of that.

``` r

run_demo("06-realistic-with-helpers")
```

The `R/` directory contains 14 files, including `logr_msg.R`,
`scatter_plot.R`, `display_type.R`, and others that define regular
functions. These are called from within modules but they are not modules
themselves.
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
correctly excludes them from the tree. Provide the non-default function
names for this app:

``` r

mod_tree(
  "inst/apps/06-realistic-with-helpers/R",
  app_fun    = "launch_app",
  ui_fun     = "movies_ui",
  server_fun = "movies_server"
)
```

``` verbatim
█─launch_app
├─█─movies_ui
│ ├─█─mod_var_input_ui
│ ├─█─mod_aes_input_ui
│ └─█─mod_scatter_display_ui
└─█─movies_server
  ├─█─mod_var_input_server
  ├─█─mod_aes_input_server
  └─█─mod_scatter_display_server
```

Even though `mod_scatter_display_server` calls `scatter_plot()`, that
function does not appear in the tree.
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
includes a function in the output only if it is a detected module or one
of the three named top-level functions.

## Recap

[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
statically parses R source files to build and print a module call graph
without running the app. The six scenarios covered here represent the
range of structures you are likely to encounter:

1.  **Default names** — no arguments beyond `path` are needed when the
    app follows `launch`/`app_ui`/`app_server` conventions.
2.  **Custom names** — supply `app_fun`, `ui_fun`, and `server_fun` when
    the top-level functions use different names.
3.  **Nested modules** —
    [`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
    follows the call graph recursively, so child modules appear at the
    correct depth.
4.  **No modules** — a flat tree is valid output; it can also indicate a
    detection miss worth investigating.
5.  **Many modules** — sibling modules fan out horizontally, ordered by
    call sequence in the source.
6.  **Helper functions** — regular functions called by modules are
    excluded from the tree; only `NS()`- or `moduleServer()`-bearing
    functions are treated as modules.
