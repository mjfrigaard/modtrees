test_that("renders root node", {
  tree <- list(name = "root", children = list())
  lines <- render_tree(tree)
  expect_equal(lines, "\u2588\u2500root")
})

test_that("renders single child", {
  tree <- list(
    name = "root",
    children = list(
      a = list(name = "a", children = list())
    )
  )
  lines <- render_tree(tree)
  expect_length(lines, 2)
  expect_match(lines[2], "a")
})

test_that("renders multiple children with correct connectors", {
  tree <- list(
    name = "root",
    children = list(
      a = list(name = "a", children = list()),
      b = list(name = "b", children = list())
    )
  )
  lines <- render_tree(tree)
  expect_length(lines, 3)
  expect_match(lines[2], "\u251C")
  expect_match(lines[3], "\u2514")
})
