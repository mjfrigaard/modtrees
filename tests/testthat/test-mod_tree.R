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

test_that("custom app_fun, ui_fun, server_fun are honoured", {
  dir <- withr::local_tempdir()

  writeLines(
    'run_app <- function() { shinyApp(ui = ui(), server = server) }',
    file.path(dir, "run_app.R")
  )
  writeLines(
    'ui <- function() { mod_counter_ui("c") }',
    file.path(dir, "ui.R")
  )
  writeLines(
    'server <- function(input, output, session) { mod_counter_server("c") }',
    file.path(dir, "server.R")
  )
  writeLines(
    'mod_counter_ui <- function(id) { ns <- NS(id); tagList() }',
    file.path(dir, "mod_counter_ui.R")
  )
  writeLines(
    'mod_counter_server <- function(id) { moduleServer(id, function(input, output, session) {}) }',
    file.path(dir, "mod_counter_server.R")
  )

  tree <- mod_tree(dir, app_fun = "run_app", ui_fun = "ui", server_fun = "server")

  expect_equal(tree$name, "run_app")
  child_names <- vapply(tree$children, `[[`, character(1), "name")
  expect_true("ui"     %in% child_names)
  expect_true("server" %in% child_names)
})

test_that("nested modules appear at the correct depth", {
  dir <- withr::local_tempdir()

  writeLines(
    'launch <- function() { shinyApp(ui = app_ui(), server = app_server) }',
    file.path(dir, "launch.R")
  )
  writeLines(
    'app_ui <- function() { mod_parent_ui("p") }',
    file.path(dir, "app_ui.R")
  )
  writeLines(
    'app_server <- function(input, output, session) { mod_parent_server("p") }',
    file.path(dir, "app_server.R")
  )
  writeLines(
    'mod_parent_ui <- function(id) { ns <- NS(id); mod_child_ui(ns("c")) }',
    file.path(dir, "mod_parent.R")
  )
  writeLines(
    'mod_parent_server <- function(id) { moduleServer(id, function(i, o, s) { mod_child_server("c") }) }',
    file.path(dir, "mod_parent_server.R")
  )
  writeLines(
    'mod_child_ui <- function(id) { ns <- NS(id); tagList() }
     mod_child_server <- function(id) { moduleServer(id, function(i, o, s) {}) }',
    file.path(dir, "mod_child.R")
  )

  tree <- mod_tree(dir)

  ui_node <- tree$children[["app_ui"]]
  expect_false(is.null(ui_node))
  expect_true("mod_parent_ui" %in% names(ui_node$children))

  parent_ui_node <- ui_node$children[["mod_parent_ui"]]
  expect_true("mod_child_ui" %in% names(parent_ui_node$children))
})

test_that("no modules produces a flat tree with only top-level functions", {
  dir <- withr::local_tempdir()

  writeLines(
    'launch <- function() { shinyApp(ui = app_ui(), server = app_server) }',
    file.path(dir, "launch.R")
  )
  writeLines(
    'app_ui <- function() { fluidPage(sliderInput("n", "n", 1, 100, 50)) }',
    file.path(dir, "app_ui.R")
  )
  writeLines(
    'app_server <- function(input, output, session) { output$txt <- renderText(input$n) }',
    file.path(dir, "app_server.R")
  )

  tree <- mod_tree(dir)

  expect_equal(tree$name, "launch")
  child_names <- vapply(tree$children, `[[`, character(1), "name")
  expect_setequal(child_names, c("app_ui", "app_server"))
  # no grandchildren
  expect_true(all(vapply(tree$children, function(ch) length(ch$children) == 0, logical(1))))
})
