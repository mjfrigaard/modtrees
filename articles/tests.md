# Test coverage and traceability

``` r

library(modtrees)
```

This vignette records which tests cover which functions, summarizes the
current state of the test suite, and documents known issues. It is
intended as a living document: update the matrix whenever tests are
added or functions change.

## Functions

`modtrees` exposes two exported functions and five internal helpers.

| Function | Type | Test file |
|----|----|----|
| [`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md) | exported | `test-mod_tree.R` |
| [`mod_tree_app()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree_app.md) | exported | `test-mod_tree_app.R` |
| [`run_demo()`](https://mjfrigaard.github.io/modtrees/reference/run_demo.md) | exported | — |
| [`build_tree()`](https://mjfrigaard.github.io/modtrees/reference/build_tree.md) | internal | `test-build_tree.R` |
| [`extract_func_def()`](https://mjfrigaard.github.io/modtrees/reference/extract_func_def.md) | internal | `test-extract_func_def.R` |
| [`find_calls()`](https://mjfrigaard.github.io/modtrees/reference/find_calls.md) | internal | `test-find_calls.R` |
| [`render_tree()`](https://mjfrigaard.github.io/modtrees/reference/render_tree.md) | internal | `test-render_tree.R` |
| [`uses_ns()`](https://mjfrigaard.github.io/modtrees/reference/uses_ns.md) | internal | `test-uses_ns.R` |

[`run_demo()`](https://mjfrigaard.github.io/modtrees/reference/run_demo.md)
is an interactive launcher with no automated tests. Its correctness is
verified manually by running each bundled app.

## Traceability matrix

Columns mark every function exercised by each test. Integration-level
tests (those in `test-mod_tree.R` and `test-mod_tree_app.R`) exercise
multiple internal helpers in a single call; those cells are marked
accordingly.

| Test description | File | mod_tree | mod_tree_app | build_tree | extract_func_def | find_calls | render_tree | uses_ns |
|:---|:---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| builds simple tree | test-build_tree |  |  | ✓ |  |  |  |  |
| handles cycles | test-build_tree |  |  | ✓ |  |  |  |  |
| handles nested modules | test-build_tree |  |  | ✓ |  |  |  |  |
| unknown root produces a root node with no children | test-build_tree |  |  | ✓ |  |  |  |  |
| extracts \<- function assignment | test-extract_func_def |  |  |  | ✓ |  |  |  |
| extracts = function assignment | test-extract_func_def |  |  |  | ✓ |  |  |  |
| returns NULL for non-function assignment | test-extract_func_def |  |  |  | ✓ |  |  |  |
| returns NULL for bare expressions | test-extract_func_def |  |  |  | ✓ |  |  |  |
| extracts assign() style | test-extract_func_def |  |  |  | ✓ |  |  |  |
| finds direct function calls | test-find_calls |  |  |  |  | ✓ |  |  |
| finds bare name references | test-find_calls |  |  |  |  | ✓ |  |  |
| ignores unknown names | test-find_calls |  |  |  |  | ✓ |  |  |
| returns unique results | test-find_calls |  |  |  |  | ✓ |  |  |
| finds calls nested inside control flow | test-find_calls |  |  |  |  | ✓ |  |  |
| errors on non-shiny.appobj input | test-mod_tree_app |  | ✓ |  |  |  |  |  |
| detects one module when UI is an unevaluated function | test-mod_tree_app |  | ✓ | ✓ |  | ✓ | ✓ | ✓ |
| app_fun sets the root label | test-mod_tree_app |  | ✓ | ✓ |  |  | ✓ |  |
| auto-detects UI function name when passed unevaluated | test-mod_tree_app |  | ✓ |  |  |  |  | ✓ |
| ui_fun fallback works when UI is pre-evaluated | test-mod_tree_app |  | ✓ | ✓ |  | ✓ |  | ✓ |
| flat tree when app has no modules | test-mod_tree_app |  | ✓ | ✓ | ✓ |  |  | ✓ |
| nested modules appear at the correct depth | test-mod_tree_app |  | ✓ | ✓ | ✓ |  |  | ✓ |
| multiple sibling modules all appear under server | test-mod_tree_app |  | ✓ | ✓ | ✓ |  |  | ✓ |
| non-module helpers called by modules do not appear in tree | test-mod_tree_app |  | ✓ |  | ✓ | ✓ |  | ✓ |
| invisibly returns the tree list | test-mod_tree_app |  | ✓ |  | ✓ |  |  |  |
| mod_tree works on a minimal app | test-mod_tree | ✓ |  | ✓ |  | ✓ | ✓ | ✓ |
| mod_tree errors gracefully on empty directory | test-mod_tree | ✓ |  | ✓ |  | ✓ | ✓ | ✓ |
| custom app_fun, ui_fun, server_fun are honoured | test-mod_tree | ✓ |  | ✓ |  | ✓ | ✓ | ✓ |
| nested modules appear at the correct depth (file-based) | test-mod_tree | ✓ |  | ✓ |  | ✓ | ✓ | ✓ |
| no modules produces a flat tree with only top-level functions | test-mod_tree | ✓ |  | ✓ |  | ✓ | ✓ | ✓ |
| renders root node | test-render_tree |  |  |  |  |  | ✓ |  |
| renders single child | test-render_tree |  |  |  |  |  | ✓ |  |
| renders multiple children with correct connectors | test-render_tree |  |  |  |  |  | ✓ |  |
| grandchild indented correctly with continuation line | test-render_tree |  |  |  |  |  | ✓ |  |
| detects direct NS() call | test-uses_ns |  |  |  |  |  |  |  |
| detects shiny::NS() call | test-uses_ns |  |  |  |  |  |  |  |
| detects moduleServer() call | test-uses_ns |  |  |  |  |  |  |  |
| detects shiny::moduleServer() call | test-uses_ns |  |  |  |  |  |  |  |
| returns FALSE for non-module function | test-uses_ns |  |  |  |  |  |  |  |

## Coverage notes

[`run_demo()`](https://mjfrigaard.github.io/modtrees/reference/run_demo.md)
has no automated tests. It wraps
[`shiny::shinyAppDir()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
with path-resolution logic; its correctness depends on the bundled apps
in `inst/apps/` being valid, which is implicitly verified whenever those
apps are rendered for manual inspection.

The
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
integration tests in `test-mod_tree.R` exercise all five internal
helpers in combination. A failure there that does not also fail the
corresponding unit test points to an interaction bug rather than a bug
in the helper itself.

## Known issues

### `extract_func_def()`: vector coercion with complex expressions

Found during wild testing against the `pffoundations` package (July
2026, 35 R source files, ~20 modules).

**Symptom:**
[`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
crashes with:

    'length = 3' in coercion to 'logical(1)'
    Calls: mod_tree -> extract_func_def

**Root cause.** Line 17 of `R/extract_func_def.R`:

``` r

op <- as.character(expr[[1]])
```

When `expr[[1]]` is a complex call rather than a name,
[`as.character()`](https://rdrr.io/r/base/character.html) returns a
character *vector*, not a scalar. The `%in%` check on line 19 then
returns a logical vector, and `&&` cannot coerce it to a scalar.

**Fix.** Take only the first element before the comparison:

``` r
op <- as.character(expr[[1]])[1]
if (op %in% c("<-", "=", "assign") && length(expr) == 3) { ...
```

Apply the same `[1]` guard to line 28:

``` r
if (is.call(val) && as.character(val[[1]])[1] == "function") {
```

**Tests to add.** A test covering a complex left-hand-side expression
that currently causes the crash:

``` r

test_that("returns NULL safely when expr[[1]] is a complex call", {
  # e.g. a namespaced assignment: pkg::name <- function() {}
  expr <- parse(text = "a::b <- function() {}")[[1]]
  expect_null(extract_func_def(expr))
})
```

**Status:** Documented; fix and regression test pending.

## Recap

- 38 tests span 7 functions across 6 test files.
- [`mod_tree()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree.md)
  and
  [`mod_tree_app()`](https://mjfrigaard.github.io/modtrees/reference/mod_tree_app.md)
  each have dedicated unit tests plus integration coverage through the
  internal helpers they call.
- [`run_demo()`](https://mjfrigaard.github.io/modtrees/reference/run_demo.md)
  is untested automatically; manual verification through `inst/apps/`
  demos covers it.
- One known bug in
  [`extract_func_def()`](https://mjfrigaard.github.io/modtrees/reference/extract_func_def.md)
  causes a crash on complex left-hand-side expressions; the fix is a
  one-character change on two lines.
