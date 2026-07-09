mod_table_ui <- function(id) {
  ns <- NS(id)
  shiny::tableOutput(ns("tbl"))
}

mod_table_server <- function(id, filter) {
  moduleServer(id, function(input, output, session) {
    output$tbl <- shiny::renderTable({
      vals <- filter()
      iris[iris$Species == vals$species &
             iris$Sepal.Length >= vals$sepal_len, ]
    })
  })
}
