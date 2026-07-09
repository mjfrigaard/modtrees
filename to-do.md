# To-Do 

## Bug: extract_func_def() fails with vector coercion error

**Status:** Found in wild testing (pffoundations package, July 2026)

### Issue
`extract_func_def()` crashes when `as.character(expr[[1]])` returns a vector with length > 1. The function then tries to use `&&` (which requires logical scalars) with the result of `%in%`, which returns a logical vector.

**Error:**
```
'length = 3' in coercion to 'logical(1)' 
Calls: mod_tree -> extract_func_def
```

### Root Cause
In `extract_func_def()`:
```r
op <- as.character(expr[[1]])
if (op %in% c("<-", "=", "assign") && length(expr) == 3) {  # ← fails here
```

When `expr[[1]]` is a complex call, `as.character()` returns a vector, and `op %in% ...` becomes a logical vector. The `&&` operator cannot coerce vectors to scalars.

### Solution
Extract first element only before the %in% check:
```r
op <- as.character(expr[[1]])[1]  # Take first element only
if (op %in% c("<-", "=", "assign") && length(expr) == 3) {
```

Also apply same fix to the nested check:
```r
if (is.call(val) && as.character(val[[1]])[1] == "function") {
```

### Use Case (Wild Testing)
Tested on real-world Shiny app-package `pffoundations`:
- 35 R source files
- ~20 Shiny modules with complex expressions
- Successfully generated module hierarchy tree once monkey-patched
- Tree output used in vignettes (`transactions.Rmd`, `categorize.Rmd`) to document module call structures

### Monkey-Patch for Testing
```r
assignInNamespace('extract_func_def', function(expr) {
  if (!is.call(expr)) return(NULL)
  op <- as.character(expr[[1]])[1]  # Fix: take first element
  if (op %in% c('<-', '=', 'assign') && length(expr) == 3) {
    name <- if (op == 'assign') {
      if (is.character(expr[[2]])) expr[[2]]
      else return(NULL)
    } else {
      if (is.name(expr[[2]])) as.character(expr[[2]])
      else return(NULL)
    }
    val <- expr[[3]]
    if (is.call(val) && as.character(val[[1]])[1] == 'function') {  # Fix: take first element
      return(list(name = name, body = val))
    }
  }
  NULL
}, ns = 'modtrees')
```

### Next Steps
1. Add defensive check for vector-length coercion in extract_func_def
2. Add unit tests covering multi-element as.character() results
3. Consider using deparse() instead of as.character() for more robust operator extraction
