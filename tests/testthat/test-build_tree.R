test_that("builds simple tree", {
  cg <- list(
    root = c("a", "b"),
    a = character(0),
    b = character(0)
  )
  tree <- build_tree("root", cg)
  expect_equal(tree$name, "root")
  expect_length(tree$children, 2)
  expect_equal(tree$children[["a"]]$name, "a")
  expect_equal(tree$children[["b"]]$name, "b")
})

test_that("handles cycles", {
  cg <- list(
    a = "b",
    b = "a"
  )
  tree <- build_tree("a", cg)
  expect_equal(tree$name, "a")
  expect_length(tree$children, 1)
  expect_length(tree$children[["b"]]$children, 0)
})

test_that("handles nested modules", {
  cg <- list(
    root = "a",
    a = "b",
    b = character(0)
  )
  tree <- build_tree("root", cg)
  expect_equal(tree$children[["a"]]$children[["b"]]$name, "b")
})
