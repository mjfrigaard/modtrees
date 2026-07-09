mod_counter_ui <- function(id) {
  ns <- NS(id)
  shiny::tagList(
    shiny::actionButton(ns("add"), "Add 1"),
    shiny::actionButton(ns("reset"), "Reset"),
    shiny::verbatimTextOutput(ns("count"))
  )
}

mod_counter_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    count <- shiny::reactiveVal(0)

    shiny::observeEvent(input$add,   { count(count() + 1) })
    shiny::observeEvent(input$reset, { count(0) })

    output$count <- shiny::renderPrint({ count() })
  })
}
