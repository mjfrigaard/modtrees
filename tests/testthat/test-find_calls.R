test_that("finds direct function calls", {
  expr <- parse(text = "function() { foo(); bar() }")[[1]]
  result <- find_calls(expr, c("foo", "bar", "baz"))
  expect_setequal(result, c("foo", "bar"))
})

test_that("finds bare name references", {
  expr <- parse(text = "function() { shinyApp(ui = my_ui, server = my_server) }")[[1]]
  result <- find_calls(expr, c("my_ui", "my_server", "other"))
  expect_setequal(result, c("my_ui", "my_server"))
})

test_that("ignores unknown names", {
  expr <- parse(text = "function() { unknown_fun() }")[[1]]
  result <- find_calls(expr, c("foo"))
  expect_length(result, 0)
})

test_that("returns unique results", {
  expr <- parse(text = "function() { foo(); foo() }")[[1]]
  result <- find_calls(expr, c("foo"))
  expect_equal(result, "foo")
})
