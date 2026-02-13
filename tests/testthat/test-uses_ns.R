test_that("detects direct NS() call", {
  expr <- parse(text = "function(id) { ns <- NS(id) }")[[1]]
  expect_true(uses_ns(expr))
})

test_that("detects shiny::NS() call", {
  expr <- parse(text = "function(id) { ns <- shiny::NS(id) }")[[1]]
  expect_true(uses_ns(expr))
})

test_that("detects moduleServer() call", {
  expr <- parse(text = "function(id) { moduleServer(id, function(input, output, session) {}) }")[[1]]
  expect_true(uses_ns(expr))
})

test_that("detects shiny::moduleServer() call", {
  expr <- parse(text = "function(id) { shiny::moduleServer(id, function(input, output, session) {}) }")[[1]]
  expect_true(uses_ns(expr))
})

test_that("returns FALSE for non-module function", {
  expr <- parse(text = "function(x) { x + 1 }")[[1]]
  expect_false(uses_ns(expr))
})
