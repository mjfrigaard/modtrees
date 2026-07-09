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

test_that("grandchild indented correctly with continuation line", {
  tree <- list(
    name = "root",
    children = list(
      a = list(
        name = "a",
        children = list(
          b = list(name = "b", children = list())
        )
      ),
      c = list(name = "c", children = list())
    )
  )
  lines <- render_tree(tree)
  # root, a (non-last), b (child of a), c (last sibling of a)
  expect_length(lines, 4)
  # 'a' is non-last so its child prefix contains the continuation character
  expect_match(lines[3], "\u2502")   # │ continuation line before b
  expect_match(lines[3], "b")
  # 'c' is last so its line uses └─
  expect_match(lines[4], "\u2514")
})
