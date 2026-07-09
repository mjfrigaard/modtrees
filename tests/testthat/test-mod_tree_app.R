library(shiny)

# ---------------------------------------------------------------------------
# Shared module helpers (defined once, reused across tests)
# ---------------------------------------------------------------------------

mod_a_ui <- function(id) {
  ns <- NS(id)
  tagList(textOutput(ns("out")))
}

mod_a_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$out <- renderText("hello")
  })
}

mod_b_ui <- function(id) {
  ns <- NS(id)
  tagList(textOutput(ns("val")))
}

mod_b_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$val <- renderText("world")
  })
}

# A child module called from mod_a (for nested tests)
mod_child_ui <- function(id) {
  ns <- NS(id)
  tagList(textOutput(ns("x")))
}

mod_child_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$x <- renderText("nested")
  })
}

# Non-module helper (should never appear in the tree)
a_helper <- function(x) x + 1

# ---------------------------------------------------------------------------
# 1. Rejects non-shiny.appobj input
# ---------------------------------------------------------------------------

test_that("errors on non-shiny.appobj input", {
  expect_error(mod_tree_app("not_an_app"), class = "simpleError")
  expect_error(mod_tree_app(list()),       class = "simpleError")
})

# ---------------------------------------------------------------------------
# 2. Basic: single module, UI passed as unevaluated function reference
# ---------------------------------------------------------------------------

test_that("detects one module when UI is an unevaluated function", {
  my_ui <- function() fluidPage(mod_a_ui("a"))
  my_server <- function(input, output, session) mod_a_server("a")

  app <- shinyApp(ui = my_ui, server = my_server)
  tree <- mod_tree_app(app)

  expect_equal(tree$name, "app")
  child_names <- vapply(tree$children, `[[`, character(1), "name")
  expect_true("my_server" %in% child_names)

  # mod_a_server appears as a grandchild under the server branch
  server_node <- tree$children[[which(child_names == "my_server")]]
  grandchild_names <- vapply(server_node$children, `[[`, character(1), "name")
  expect_true("mod_a_server" %in% grandchild_names)
})

# ---------------------------------------------------------------------------
# 3. Custom app_fun label overrides the root node name
# ---------------------------------------------------------------------------

test_that("app_fun sets the root label", {
  my_ui     <- function() fluidPage()
  my_server <- function(input, output, session) {}

  app  <- shinyApp(ui = my_ui, server = my_server)
  tree <- mod_tree_app(app, app_fun = "launch")

  expect_equal(tree$name, "launch")
})

# ---------------------------------------------------------------------------
# 4. UI auto-detected when passed unevaluated
# ---------------------------------------------------------------------------

test_that("auto-detects UI function name when passed unevaluated", {
  named_ui     <- function() fluidPage(mod_a_ui("a"))
  named_server <- function(input, output, session) mod_a_server("a")

  app <- shinyApp(ui = named_ui, server = named_server)
  tree <- mod_tree_app(app)

  child_names <- vapply(tree$children, `[[`, character(1), "name")
  expect_true("named_ui" %in% child_names)
})

# ---------------------------------------------------------------------------
# 5. Pre-evaluated UI: ui_fun fallback resolves the UI branch
# ---------------------------------------------------------------------------

test_that("ui_fun fallback works when UI is pre-evaluated", {
  pre_ui     <- function() fluidPage(mod_a_ui("a"))
  pre_server <- function(input, output, session) mod_a_server("a")

  app  <- shinyApp(ui = pre_ui(), server = pre_server)   # UI evaluated here
  tree <- mod_tree_app(app, ui_fun = "pre_ui")

  child_names <- vapply(tree$children, `[[`, character(1), "name")
  expect_true("pre_ui" %in% child_names)
})

# ---------------------------------------------------------------------------
# 6. No modules: server calls no moduleServer() functions
# ---------------------------------------------------------------------------

test_that("flat tree when app has no modules", {
  plain_ui     <- function() fluidPage(sliderInput("n", "n", 1, 100, 50))
  plain_server <- function(input, output, session) {
    output$txt <- renderText(input$n)
  }

  app  <- shinyApp(ui = plain_ui, server = plain_server)
  tree <- mod_tree_app(app)

  # root has server (and maybe ui) but no module grandchildren
  server_node <- Filter(
    function(ch) ch$name == "plain_server",
    tree$children
  )
  expect_length(server_node, 1)
  expect_length(server_node[[1]]$children, 0)
})

# ---------------------------------------------------------------------------
# 7. Nested modules: module that calls a child module
# ---------------------------------------------------------------------------

test_that("nested modules appear at the correct depth", {
  parent_ui <- function(id) {
    ns <- NS(id)
    tagList(mod_child_ui(ns("child")))
  }
  parent_server <- function(id) {
    moduleServer(id, function(input, output, session) {
      mod_child_server("child")
    })
  }

  top_ui     <- function() fluidPage(parent_ui("p"))
  top_server <- function(input, output, session) parent_server("p")

  app  <- shinyApp(ui = top_ui, server = top_server)
  tree <- mod_tree_app(app)

  # top_server -> parent_server -> mod_child_server
  server_node <- Filter(function(ch) ch$name == "top_server", tree$children)
  expect_length(server_node, 1)
  grand <- server_node[[1]]$children
  grand_names <- vapply(grand, `[[`, character(1), "name")
  expect_true("parent_server" %in% grand_names)

  parent_node <- grand[[which(grand_names == "parent_server")]]
  great_names <- vapply(parent_node$children, `[[`, character(1), "name")
  expect_true("mod_child_server" %in% great_names)
})

# ---------------------------------------------------------------------------
# 8. Many sibling modules
# ---------------------------------------------------------------------------

test_that("multiple sibling modules all appear under server", {
  wide_ui <- function() {
    fluidPage(mod_a_ui("a"), mod_b_ui("b"))
  }
  wide_server <- function(input, output, session) {
    mod_a_server("a")
    mod_b_server("b")
  }

  app  <- shinyApp(ui = wide_ui, server = wide_server)
  tree <- mod_tree_app(app)

  server_node <- Filter(function(ch) ch$name == "wide_server", tree$children)
  grand_names <- vapply(server_node[[1]]$children, `[[`, character(1), "name")
  expect_true("mod_a_server" %in% grand_names)
  expect_true("mod_b_server" %in% grand_names)
})

# ---------------------------------------------------------------------------
# 9. Helper functions are excluded from the tree
# ---------------------------------------------------------------------------

test_that("non-module helpers called by modules do not appear in tree", {
  helper_server <- function(input, output, session) {
    mod_a_server("a")
    a_helper(42)   # regular function; must not appear in tree
  }

  app  <- shinyApp(ui = fluidPage(), server = helper_server)
  tree <- mod_tree_app(app)

  all_names <- function(node) {
    c(node$name, unlist(lapply(node$children, all_names)))
  }
  expect_false("a_helper" %in% all_names(tree))
})

# ---------------------------------------------------------------------------
# 10. Invisible return value matches printed structure
# ---------------------------------------------------------------------------

test_that("invisibly returns the tree list", {
  simple_ui     <- function() fluidPage()
  simple_server <- function(input, output, session) {}

  app  <- shinyApp(ui = simple_ui, server = simple_server)
  tree <- mod_tree_app(app)

  expect_type(tree, "list")
  expect_named(tree, c("name", "children"))
})
