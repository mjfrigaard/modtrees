# Getting Started

``` r

library(modtrees)
```

As a Shiny app grows, the module hierarchy gets harder to hold in your
head. You end up tracing through multiple files to answer a simple
question: which module calls which? `modtrees` addresses this by
statically parsing the R source files in a directory and printing the
call graph as a plain-text tree, without running the app.

This vignette walks through the six example applications bundled with
`modtrees`. Each one isolates a specific scenario you’re likely to
encounter when using
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
on a real project.

## The `mod_tree()` function

[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
takes four arguments:

- `path`: the directory containing R source files (defaults to `"R"`)
- `app_fun`: the top-level launch function name (defaults to `"launch"`)
- `ui_fun`: the UI function name (defaults to `"app_ui"`)
- `server_fun`: the server function name (defaults to `"app_server"`)

The function parses every `.R` file in `path`, identifies functions that
use `NS()` or `moduleServer()` as Shiny modules, builds a call graph,
and performs a depth-first traversal starting from `app_fun`. The result
is printed to the console.

Use
[`run_demo()`](https://mjfrigaard.github.io/modtrees/reference/run_demo.md)
to launch any of the bundled apps interactively so you can inspect their
source before running
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
on them.

## Default names

The simplest case: a single module nested under `app_ui` and
`app_server`, with all function names matching
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)’s
defaults. No arguments beyond `path` are needed.

``` r

run_demo("01-default-names")
```

The `R/` directory for this app contains `launch.R`, `app_ui.R`,
`app_server.R`, and `mod_greet.R`. Point
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
at it:

``` r

mod_tree("inst/apps/01-default-names/R")
```

``` verbatim
█─launch
├─█─app_ui
│ └─█─mod_greet_ui
└─█─app_server
  └─█─mod_greet_server
```

The root is `launch`, its two children are `app_ui` and `app_server`,
and each carries a single module leaf.

## Custom names

Real apps rarely use `launch`, `app_ui`, and `app_server` verbatim. When
the top-level functions have different names, pass them explicitly.

``` r

run_demo("02-custom-names")
```

This app uses `run_app()` as the launcher, `ui()` for the interface, and
`server()` for the server logic. Calling
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
without the extra arguments would start the traversal from a function
named `"launch"` that doesn’t exist, producing an empty tree. Supply the
correct names instead:

``` r

mod_tree(
  "inst/apps/02-custom-names/R",
  app_fun    = "run_app",
  ui_fun     = "ui",
  server_fun = "server"
)
```

``` verbatim
█─run_app
├─█─ui
│ └─█─mod_counter_ui
└─█─server
  └─█─mod_counter_server
```

The tree is structurally identical to the previous one; only the
function names differ.
