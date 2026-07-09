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

## The same tree from a live app object

[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
works by parsing files on disk.
[`mod_tree_app()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree_app.md)
takes a different entry point: a `shiny.appobj` created by
[`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html).
Everything else — module detection, call-graph traversal, rendering —
uses the same internals.

To use
[`mod_tree_app()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree_app.md)
on this app, build the app object first by passing the UI and server
functions as unevaluated references (no parentheses):

``` r

app <- shiny::shinyApp(ui = movies_ui, server = movies_server)
```

Then call
[`mod_tree_app()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree_app.md)
with the same named arguments:

``` r

mod_tree_app(
  app,
  app_fun    = "launch_app",
  ui_fun     = "movies_ui",
  server_fun = "movies_server"
)
```

The output is identical to the file-based call above:

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

### Pre-evaluated UI

When `ui` is passed to `shinyApp()` with parentheses —
`shinyApp(ui = movies_ui(), ...)` — the UI is evaluated immediately into
an HTML object and the function body is no longer recoverable from the
app object. In that case, supply `ui_fun` as a character string.
[`mod_tree_app()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree_app.md)
will look the function up by name from the server’s enclosing
environment and use its body for the UI branch:

``` r

app_pre <- shiny::shinyApp(ui = movies_ui(), server = movies_server)

mod_tree_app(
  app_pre,
  app_fun    = "launch_app",
  ui_fun     = "movies_ui",
  server_fun = "movies_server"
)
```

The tree is the same either way; the only difference is whether
[`mod_tree_app()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree_app.md)
can find the UI function automatically.

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
7.  **Live app object** —
    [`mod_tree_app()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree_app.md)
    accepts a `shiny.appobj` and produces the same tree as
    [`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
    without touching the file system; use it when the app is already in
    memory or when a path is unavailable.
