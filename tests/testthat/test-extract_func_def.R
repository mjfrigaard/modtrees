test_that("extracts <- function assignment", {
  expr <- parse(text = "my_fun <- function(x) { x + 1 }")[[1]]
  result <- extract_func_def(expr)
  expect_equal(result$name, "my_fun")
  expect_true(is.call(result$body))
})

test_that("extracts = function assignment", {
  expr <- parse(text = "my_fun = function(x) { x + 1 }")[[1]]
  result <- extract_func_def(expr)
  expect_equal(result$name, "my_fun")
})

test_that("returns NULL for non-function assignment", {
  expr <- parse(text = "x <- 5")[[1]]
  expect_null(extract_func_def(expr))
})

test_that("returns NULL for bare expressions", {
  expr <- parse(text = "print('hello')")[[1]]
  expect_null(extract_func_def(expr))
})

test_that("extracts assign() style", {
  expr <- parse(text = 'assign("my_fun", function(x) x)')[[1]]
  result <- extract_func_def(expr)
  expect_equal(result$name, "my_fun")
})
