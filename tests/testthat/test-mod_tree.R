test_that("mod_tree works on a minimal app", {
  dir <- withr::local_tempdir()

  writeLines(
    'app_ui <- function() { ns <- shiny::NS("app"); mod_a_ui("a") }',
    file.path(dir, "app_ui.R")
  )
  writeLines(
    'app_server <- function(input, output, session) { mod_a_server("a") }',
    file.path(dir, "app_server.R")
  )
  writeLines(
    'launch <- function() { shinyApp(ui = app_ui(), server = app_server) }',
    file.path(dir, "launch.R")
  )
  writeLines(
    'mod_a_ui <- function(id) { ns <- NS(id); tagList() }',
    file.path(dir, "mod_a.R")
  )
  writeLines(
    'mod_a_server <- function(id) { moduleServer(id, function(input, output, session) {}) }',
    file.path(dir, "mod_a_server.R")
  )

  tree <- mod_tree(dir)

  expect_equal(tree$name, "launch")
  expect_length(tree$children, 2)
  child_names <- vapply(tree$children, `[[`, character(1), "name")
  expect_true("app_ui" %in% child_names)
  expect_true("app_server" %in% child_names)
})

test_that("mod_tree errors gracefully on empty directory", {
  dir <- withr::local_tempdir()
  expect_output(mod_tree(dir), "\u2588\u2500launch")
})
